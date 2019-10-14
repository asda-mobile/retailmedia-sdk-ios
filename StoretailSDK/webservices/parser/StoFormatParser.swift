//
//  StoFormatParser.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 14/06/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation

internal class StoFormatParser {
    private let TAG = "StoFormatParser"
    
    private var parser : StoFormatParserProtocol? = nil
    private var placement: StoResponsePlacement?
    
    init(response: StoResponseLod) {
        self.placement = response.creatives.placements
    }
    
    internal func parse() -> [StoFormat] {
        if let parser = self.parser, let placement = self.placement {
            return parser.getStoFormats(placement: placement)
        }
        return []
    }
    
    internal func parseCustom() -> [StoFormat] {
        var result = [StoFormat]()
        if let placement = self.placement {
            
            for customFormat in placement.custom {
                let stoFormatCustom = StoFormatCustom(response: customFormat.values, formatName: customFormat.formatName!)
                
                // Sets the queryStringparams to the stoMenuItemDecor
                stoFormatCustom.queryStringParamsList = customFormat.getQSP(type: stoFormatCustom.getFormatName())
                result.append(stoFormatCustom)
            }
        }
        return result
    }
    
    internal func setParser(parser: StoFormatParserProtocol) { self.parser = parser }
}

internal protocol StoFormatParserProtocol {
    func getTag() -> String
    func getStoFormatKey() -> String
    func getStoFormats(placement: StoResponsePlacement) -> [StoFormat]
}
