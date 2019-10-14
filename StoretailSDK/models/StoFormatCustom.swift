//
//  StoFormatCustom.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 23/07/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import AnyCodable

public class StoFormatCustom: StoFormat {
    private var formatName: String
    private var path : String
    private var values : [String: AnyCodable]
    
    init(response : [String: AnyCodable], formatName: String) {
        var valuesCopy = response
        
        if let path = valuesCopy["path"] {
            self.path = "\(StoFormat.EXTERNAL_URL_PROTOCOL)\(path)"
            
            valuesCopy.removeValue(forKey: "path")
        } else {
            self.path = ""
        }
        self.values = valuesCopy
        self.formatName = formatName
        
        super.init(formatType: .stoCustom, optionType: .none)
    }
    
    public func getFormatName() -> String { return self.formatName }
    public func getPath() -> String { return self.path }
    public func getValues() -> [String: AnyCodable] { return self.values }
    
    override public var description: String {
        return "\(formatName) : \(queryStringParamsList) \(values)"
    }
}
