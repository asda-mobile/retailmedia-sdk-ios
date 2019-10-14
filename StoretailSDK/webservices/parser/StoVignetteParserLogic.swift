//
//  StoVignetteParserLogic.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 24/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import Foundation

internal class StoVignetteParserLogic : StoFormatParserProtocol {
    
    func getTag() -> String {
        return "StoVignetteParserLogic"
    }
    
    func getStoFormatKey() -> String {
        return "VI"
    }
    
    func getStoFormats(placement: StoResponsePlacement) -> [StoFormat] {
        var result : [StoFormat] = []
        
        for vi in placement.vi {
            let stoVignette = StoVignette(response: vi.values)
            
            // Sets the queryStringparams to the stoMenuItemDecor
            stoVignette.queryStringParamsList = vi.getQSP(type: getStoFormatKey())
            result.append(stoVignette)
        }
        
        return result
    }
}
