//
//  StoMBFParserLogic.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 17/06/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import AnyCodable

internal class StoButterflyParserLogic : StoFormatParserProtocol {
    
    func getTag() -> String {
        return "StoButterflyParserLogic"
    }
    
    func getStoFormatKey() -> String {
        return "BF"
    }
    
    func getStoFormats(placement: StoResponsePlacement) -> [StoFormat] {
        var result : [StoFormat] = []
        
        for mbf in placement.bf {
            var mbfFormat : StoFormat? = nil
            
            if let buttons = mbf.values.products {
                // It's a Butterfly
                let stoButterfly = StoButterfly(response: mbf.values)
                if setButterflyButtons(buttons: buttons, stoButterfly: stoButterfly) == true {
                    mbfFormat = stoButterfly
                } else {
                    StoLog.w(message: "\(getTag()): Butterfly buttons error")
                }
            }
            if let mbfFormat = mbfFormat {
                // Sets the queryStringparams to the stoMenuItemDecor
                mbfFormat.queryStringParamsList = mbf.getQSP(type: getStoFormatKey())
                result.append(mbfFormat)
            }
        }
        
        return result
    }
    
    private func setButterflyButtons(buttons: [[AnyCodable]], stoButterfly: StoButterfly) -> Bool {
        if buttons.count == 0 {
            return false
        }
        
        var stoButtonContentList = Array<StoButtonContent>()
        for button in buttons {
            // Gets the button's position
            guard let btn_pos = button[0].value as? String else{
                StoLog.e(message: "\(getTag()): getButtonContent: cannot extract the position of the button")
                continue
            }
            // Gets the button's name
            guard let btn_name = button[1].value as? String else{
                StoLog.e(message: "\(getTag()): getButtonContent: cannot extract the name of the button")
                continue
            }
            
            // Verifies if it's an exclusive button
            guard let btn_excl = button[2].value as? Bool else{
                StoLog.e(message: "\(getTag()): getButtonContent: cannot extract isExcluded button")
                continue
            }
            
            // Retrieves the array of products ids
            guard let btn_prod_ids = button[3].value as? [String] else{
                StoLog.e(message: "\(getTag()): getButtonContent: product ids list of the button \(btn_name) is null, or cannot be downcasted to NSArray")
                continue
            }
            
            let stoButtonContent:StoButtonContent = StoButtonContent()
            stoButtonContent.buttonName = btn_name
            stoButtonContent.position = Int(btn_pos)!
            stoButtonContent.isMandatory = btn_excl
            stoButtonContent.productIds = btn_prod_ids
            
            stoButtonContentList.append(stoButtonContent)
        }
        
        // Verifies if the buttonContent list is not empty
        if !stoButtonContentList.isEmpty{
            // Sorts the list
            stoButtonContentList = stoButtonContentList.sorted(by: { (s1: StoButtonContent, s2: StoButtonContent) -> Bool in
                return s1.position < s2.position
            })
            
            // Sets the buttonContentList
            stoButterfly.setButtonContentList(list: stoButtonContentList)
            return true
        } else{
            StoLog.e(message: "\(getTag()) - setButterflyButtons: buttonContentList is empty!")
            return false
        }
    }
}
