//
//  RequestHandler.swift
//  StoRetailerApp
//
//  Created by Mikhail on 03/07/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import AEXML

public class StoRequestHandler{
    
    private let TAG: String = "StoRequestHandler"
    
    // MARK: Properties
    private var stoResponseHandler: StoResponseHandler
    
    init(stoTrackerHelper: StoTrackerHelper){
        self.stoResponseHandler = StoResponseHandler()
    }
    
    // DispatchQueue for handling responses asynchronously
    private let queue = DispatchQueue(label: "com.storetail.request.queue", qos: .utility, attributes: [.concurrent])
    
    /// Sends a get request to the server
    ///
    /// - Parameter stringQuery: <#stringQuery description#>
    internal func requestGet(stringQuery: String, identifier: String? = nil){
        // Async request
        Alamofire.request(stringQuery).responseJSON(queue: queue, options: .allowFragments, completionHandler: { response in
            // Verifies if the the data and the utf8Text are not null
            if let data = response.data {
                //Parse the response
                if stringQuery.contains("ta=lod") {
                    self.stoResponseHandler.handleResponse(responseData: data, identifier: identifier)
                }
            }else{
                self.stoResponseHandler.handleFailure(message: response.description, identifier: identifier)
            }
        })
    }
    
    func requestPost(url_to_request: String, data: AEXMLDocument){
        StoLog.d(message: "\(self.TAG): requestPost: \(url_to_request)")
        StoLog.d(message: "\(self.TAG): requestPost: \(data.xml)")
        var param = "bk="
    
        // data.xml est un String
        param.append(contentsOf: data.xml)
        
        let session = URLSession.shared
        let url:URL = URL(string: url_to_request)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = param.data(using: .utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
    
            if data != nil{
                StoLog.e(message: "\(self.TAG): requestPost: data is not null!")
            }
            
            if response != nil{
                StoLog.e(message: "\(self.TAG): requestPost: response is not null!")
            }
            
            if error != nil{
                StoLog.e(message: "\(self.TAG): requestPost: error is not null!")
                self.stoResponseHandler.handleFailure(message: error.debugDescription, identifier: nil)
            }
            
            StoLog.i(message: "\(self.TAG): requestPost in response")
        })
        task.resume()
    }
}

