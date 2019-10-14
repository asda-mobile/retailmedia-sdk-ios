//
//  StoResponseHandler.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 01/08/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import UIKit


/// Hanldes the responses
public class StoResponseHandler{
    
    private let TAG: String = "StoResponseHandler"

    private var stoResponseParser: StoResponseParser
    
    init() {
        self.stoResponseParser = StoResponseParser()
    }
    
    internal func handleResponse(responseData: Data, identifier: String?) {
        if let responseStr = String(data: responseData, encoding: .utf8) {
            StoLog.d(message: "\(self.TAG): handleResponse: response: \(responseStr)")
        }
        
        do {
            let lodResponse = try JSONDecoder().decode(StoResponseLod.self, from: responseData)
            StoLog.d(message: "\(self.TAG): LodResponse: \(lodResponse)")
            
            // Retrives formats from the response
            let stoFormats: [StoFormat]  = self.stoResponseParser.getStoFormats(response: lodResponse)
            
            // Calls no-exp request
            let noexpParams = lodResponse.creatives.getNoExpParams()
            
            for qsp in noexpParams{
                StoTracker.sharedInstance.noexp(queryStringParams: qsp)
            }
            
            if stoFormats.isEmpty{
                StoLog.i(message: "\(self.TAG): handleResponse: no formats")
                return
            }
            
            if StoEventCommunicator.sharedInstance.hasStoFormatsListeners() {
                StoLog.d(message: "\(self.TAG): handleResponse: return formats to listeners")
                
                let stoFormatsListeners = StoEventCommunicator.sharedInstance.getFormatsListeners()
                
                for x in stoFormatsListeners {
                    x.onStoFormatsReceived(formatsList: stoFormats, identifier: identifier)
                }
            }
        } catch let error as NSError {
            StoLog.e(message: "\(self.TAG): handleResponse \(error)")
        }
    }
    
    internal func handleFailure(message: String, identifier: String?){
        let stoFormatsListeners = StoEventCommunicator.sharedInstance.getFormatsListeners()
        for x in stoFormatsListeners{
            x.onStoFailure(message: message, identifier: identifier)
        }
    }
}
