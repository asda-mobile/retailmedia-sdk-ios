//
//  StoTrackerUtils.swift
//  StoRetailerApp
//
//  Created by Mikhail on 04/07/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import UIKit
import AEXML
import AdSupport
import SwiftHash


public class StoTrackerUtils{
    
    private static let TAG: String = "StoTrackerUtils"
    
    private static let randomizedUID_length:Int = 30
    
    internal enum DeviceModel: String{
        case iPad = "iPad"
        case iPhone = "iPhone"
    }
    
    // MARK: TODO: set the unique ID
    // Returns the client device id
    internal static func getIDFA() -> String?{
        
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled{
            let result = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            StoLog.d(message: "\(self.TAG): getDeviceId: idfa \(result)")
            return result
        }
    
        StoLog.d(message: "\(self.TAG): getDeviceId: the user has limited ad tracking")
        return nil
    }
    
    internal static func getRandomizedUID() -> String{
        let randomString = self.randomStringWithLength(len: self.randomizedUID_length) as String
        return MD5(randomString)
    }
    
    internal static func getDeviceModel() -> String{
        let systemVersion = UIDevice.current.model
        return systemVersion
    }
    
    
    /// Returns the key word with no non alphanumeric characters and no spaces, 
    /// they are replaced by underscores
    ///
    /// - Parameter key_word: <#key_word description#>
    /// - Returns: <#return value description#>
    internal static func getFormattedRetailSearch(retailSearch: String) -> String{
        //Verifies if the keyword is empty
        if retailSearch.isEmpty || retailSearch.trimmingCharacters(in: .whitespaces).isEmpty{
            return ""
        }
        
        var result = retailSearch.folding(options: .diacriticInsensitive, locale: .current)
        let regex = try! NSRegularExpression(pattern: "[^A-Za-z0-9.,]", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, result.count)
        result = regex.stringByReplacingMatches(in: result, options: [], range: range, withTemplate: "_")
        result = result.replacingOccurrences(of: ",", with: ".", options: .regularExpression, range: nil)
        result = result.replacingOccurrences(of: "_{2,}", with: "_", options: .regularExpression, range: nil)
        
        result = "_" + result + "_"
        
        result = result.replacingOccurrences(of: "_{2,}", with: "_", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespaces).lowercased()
        
        StoLog.d(message: "\(self.TAG): getFormattedRetailSearch: \(result)")
        return result
    }
    
    internal static func getFormattedProductLabel(productLabel: String) -> String{
        if productLabel.isEmpty || productLabel.trimmingCharacters(in: .whitespaces).isEmpty{
            return ""
        }
        
        var result = productLabel.folding(options: .diacriticInsensitive, locale: .current)
        
        let regex = try! NSRegularExpression(pattern: "[^A-Za-z0-9.,]", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, result.count)
        result = regex.stringByReplacingMatches(in: result, options: [], range: range, withTemplate: "_")
        result = result.replacingOccurrences(of: ",", with: ".", options: .regularExpression, range: nil)
        
        result = result.replacingOccurrences(of: "_{2,}", with: "_", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespaces).lowercased()
        
        StoLog.d(message: "\(self.TAG): getFormattedProductLabel: \(result)")
        
        return result
    }
    
    internal static func getFormattedForcedCity(forcedCity: String) -> String{
        if forcedCity.isEmpty || forcedCity.trimmingCharacters(in: .whitespaces).isEmpty{
            return ""
        }
        
        var result = forcedCity.folding(options: .diacriticInsensitive, locale: .current)
        
        let regex = try! NSRegularExpression(pattern: "[^A-Za-z0-9.,]", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, result.count)
        result = regex.stringByReplacingMatches(in: result, options: [], range: range, withTemplate: "_")
        result = result.replacingOccurrences(of: ",", with: ".", options: .regularExpression, range: nil)
        
        result = result.replacingOccurrences(of: "_{2,}", with: "_", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespaces).lowercased()
        
        StoLog.d(message: "\(self.TAG): getFormattedForcedCity: \(result)")
        return result
    }
    
    public static func getFormattedRetailPage(retailPages: String...) -> String {
        let retailPage = retailPages.joined(separator: "/")
        
        if retailPage.isEmpty || retailPage.trimmingCharacters(in: .whitespaces).isEmpty{
            return ""
        }
        
        var result = retailPage.folding(options: .diacriticInsensitive, locale: .current)
        let regex = try! NSRegularExpression(pattern: "[^A-Za-z0-9/]", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, result.count)
        result = regex.stringByReplacingMatches(in: result, options: [], range: range, withTemplate: "_")
        result = result.replacingOccurrences(of: "_{2,}", with: "_", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespaces).lowercased()
        
        StoLog.d(message: "\(self.TAG):   : \(result)")
        
        return result
    }

    
    /// Creates a XML document for sending POST Request
    ///
    /// - Parameter stoProductBasketList: <#stoProductBasketList description#>
    /// - Returns: <#return value description#>
    internal static func getAEXMLDocument(stoProductBasketList: [StoProduct], purchaseOrderNumber: String) -> AEXMLDocument?{
        // Verifies if the stoProductBasketList is not null
        if(stoProductBasketList.isEmpty){
            StoLog.e(message: "\(self.TAG): getAEXMLDocument: stoProductList is empty!")
            return nil
        }
        
        // Creates the AEXMLDocument
        let element_root = AEXMLDocument()
        
        // Adds the bsk element
        let element_basket = element_root.addChild(name: "bsk")
        
        // Adds the itms element
        let element_items = element_basket.addChild(name: "itms")
        
        // Adds all products to the XML
        for stoProduct in stoProductBasketList {
            
            // Li element
            let element_li = element_items.addChild(name: "li")
            
            // Product id element
            let element_product_id = element_li.addChild(name: "id")
            
            // Product id cannot be an empty String
            if stoProduct.id.isEmpty {
                StoLog.e(message: "\(self.TAG): getAEXMLDocument: stoProductBasket productId is empty!")
                return nil
            }
            
            element_product_id.value = stoProduct.id
            
            // Product name element
            let element_product_name = element_li.addChild(name: "name")
            
            // Verifies if the name is not emtpy
            if !stoProduct.name.isEmpty{
                element_product_name.value = getFormattedProductLabel(productLabel: stoProduct.name)
            } else{
                StoLog.e(message: "\(self.TAG): getAEXMLDocument: stoProductBasket's name is emtpy! No XML will be returned!")
                return nil
            }
            
            // Product promo element
            let element_product_promo = element_li.addChild(name: "promo")
            element_product_promo.value = stoProduct.promo ? "Y" : "N"
            
            // Product quantity element
            let element_product_quantity = element_li.addChild(name: "qty")
            
            // Product quantity has to be > 0
            if stoProduct.quantity == 0 {
                StoLog.e(message: "\(self.TAG): getAEXMLDocument: stoProductBasket' quantity can't equal 0")
                return nil
            }
            
            element_product_quantity.value = String(stoProduct.quantity)
            
            // Product element price
            let element_product_price = element_li.addChild(name: "price")
            
            // Calculates the total price of the product (quantity * price)
            if stoProduct.price != 0.0 {
                element_product_price.value = String(stoProduct.price)
            } else{
                StoLog.w(message: "\(self.TAG): getAEXMLDocument: product_price not set !")
            }
        }
        
        // Calculates the total price of the basket
        var total_price: Double = 0.0
        
        for stoProduct in stoProductBasketList{
            total_price = total_price + stoProduct.price * Double(stoProduct.quantity)
        }
        
        StoLog.d(message: "\(self.TAG): getAEXMLDocument: total basket price: \(total_price)")
        
        
        // Total price element
        let element_total_price = element_basket.addChild(name: "tv")
        element_total_price.value = String(total_price)

        // Purchase order number
        if !purchaseOrderNumber.isEmpty{
            let element_basket_id = element_basket.addChild(name: "id")
            element_basket_id.value = String(purchaseOrderNumber)
        }

        return element_root
    }
    
    
    
    /// Returns a XML file
    ///
    /// - Parameter product: <#product description#>
    /// - Returns: <#return value description#>
    internal static func getAEXMLDocument(product: StoProduct, trackEventValue: StoTrackEventValue = StoTrackEventValue.QuantityMore) -> AEXMLDocument?{
        
        if trackEventValue != StoTrackEventValue.AbkBtn &&
            trackEventValue != StoTrackEventValue.QuantityLess &&
            trackEventValue != StoTrackEventValue.QuantityMore &&
            trackEventValue != StoTrackEventValue.QuantityChange{

            StoLog.e(message: "\(self.TAG): getAEXMLDocument: trackEventValue not accepted: \(trackEventValue.description) ")
            return nil
        }

        // Creates the AEXMLDocument
        let element_root = AEXMLDocument()
        
        // Root element
        let element_bsk = element_root.addChild(name: "bsk")
        
        // Items element
        let element_itms = element_bsk.addChild(name: "itms")
        
        // Li element
        let element_li = element_itms.addChild(name: "li")
        
        // Product id element
        let element_product_id = element_li.addChild(name: "id")
        element_product_id.value = product.id
        
        // Product name element
        let element_product_name = element_li.addChild(name: "name")
        
        // Product's name cannot be emtpy
        if !product.name.isEmpty{
            element_product_name.value = getFormattedProductLabel(productLabel: product.name)
        } else{
            StoLog.e(message: "\(self.TAG): getAEXMLDocument: product's name is empty! No XML will be returned!")
            return nil
        }
        
        // Product promo element
        let element_product_promo = element_li.addChild(name: "promo")
        element_product_promo.value = product.promo ? "Y" : "N"
        
        // Product quantity element
        let element_product_quantity = element_li.addChild(name: "qty")
        // Verifies the trackEventValue
        if trackEventValue != StoTrackEventValue.QuantityLess{
            element_product_quantity.value = "1"
        } else{
            element_product_quantity.value = "-1"
        }
        
        // Product and total price element
        let element_product_price = element_li.addChild(name: "price")
        let element_total_price = element_bsk.addChild(name: "tv")
        var price = product.price
        // Sets the product price
        element_product_price.value = String(describing: price)
        if trackEventValue == StoTrackEventValue.QuantityLess{
            price = -1 * price
        }
        element_total_price.value = String(price)
        
        return element_root
    }
    
    
    /// Returns a randomized String
    ///
    /// - Parameter len: <#len description#>
    /// - Returns: <#return value description#>
    internal static func randomStringWithLength(len: Int) -> NSString {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0...len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
}
