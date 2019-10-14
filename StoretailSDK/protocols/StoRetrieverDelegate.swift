//
//  StoRetrieverDelegate.swift
//  StoretailSDK
//
//  Created by Mikhail POGORELOV on 12/04/2018.
//  Copyright © 2018 Mikhail POGORELOV. All rights reserved.
//

import Foundation

public protocol StoRetrieverDelegate{

    /// Returns a product by id
    ///
    /// - Parameter productId: the id of the product you want to retrieve
    /// - Returns:
    func stoGetStoProductById(productId: String) -> StoProduct?
    
    /// Returns the list of StoProduct
    ///
    /// - Parameter ids: <#ids description#>
    /// - Returns: <#return value description#>
    func stoGetStoProductsByIds(ids: [String]) -> [StoProduct]?
    
    
    /// Returns the list of product of the basket
    ///
    /// - Returns: <#return value description#>
    func stoGetBasketProducts() -> [StoProduct]?
}
