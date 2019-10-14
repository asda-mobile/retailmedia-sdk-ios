//
//  StoBannerParserLogic.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 25/07/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation

internal class StoBannerParserLogic : StoFormatParserProtocol {
    
    func getTag() -> String {
        return "StoBannerParserLogic"
    }
    
    func getStoFormatKey() -> String {
        return "BA"
    }
    
    func getStoFormats(placement: StoResponsePlacement) -> [StoFormat] {
        var result : [StoFormat] = []
        
        for ba in placement.ba {
            let stoBanner = StoBanner(response: ba.values)
            
            // Sets the queryStringparams to the stoMenuItemDecor
            stoBanner.queryStringParamsList = ba.getQSP(type: getStoFormatKey())
            result.append(stoBanner)
        }
        
        return result
    }
}
