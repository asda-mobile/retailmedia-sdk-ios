//
//  StoMBF.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 07/11/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation

protocol StoFormatProcol {
    func getFormatType() -> StoFormatType
    func getOptionType() -> StoFormatOptionType
}

@objc public class StoFormat : NSObject {
    internal static let EXTERNAL_URL_PROTOCOL : String = "https:"
    
    // Type of format
    private var formatType : StoFormatType
    private var optionType : StoFormatOptionType
    
    // Unique ID
    public internal(set) var uniqueID: String
    
    // Position of the view
    internal var position: Int
    
    // List of queryStringParams which is attached to the view
    internal var queryStringParamsList: [QueryStringParam]

    init(formatType : StoFormatType, optionType : StoFormatOptionType) {
        self.formatType = formatType
        self.optionType = optionType
        self.uniqueID = StoFormat.randomStringWithLength(len: 20)
        self.position = -1
        self.queryStringParamsList = Array()
    }
    
    /// Returns a randomized String
    ///
    /// - Parameter len: legnth of string
    /// - Returns: a ramdom generated string 
    internal static func randomStringWithLength(len: Int) -> String {
        let letters : String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString = ""
        
        for _ in 0...len {
            let length = UInt32(letters.count)
            let rand = arc4random_uniform(length)
            randomString.append(letters[letters.index(letters.startIndex, offsetBy: Int(rand))])
        }
        
        return randomString
    }
}

extension StoFormat : StoFormatProcol {
    func getFormatType() -> StoFormatType { return self.formatType }
    func getOptionType() -> StoFormatOptionType { return self.optionType }
}
