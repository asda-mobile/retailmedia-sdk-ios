//
//  StoCrawl.swift
//  StoretailSDK
//
//  Created by Mikhail POGORELOV on 13/06/2018.
//  Copyright © 2018 Mikhail POGORELOV. All rights reserved.
//

import Foundation

internal class StoCrawl{
    
    private let TAG = "StoCrawl"
    
    internal var stoProductContainer: StoProductContainer
    
    internal static let sharedInstance = StoCrawl()
    
    init(){
        stoProductContainer = StoProductContainer()
    }
    
    internal func contains(id: String) -> Bool{
        return self.stoProductContainer.stoProductList.contains(where: {$0.id == id})
    }
    
    internal func getProduct(byId id: String) -> StoProduct?{
        return self.stoProductContainer.getProduct(byId: id)
    }
    
    internal func getProducts(ids: [String]?) -> [StoProduct]?{
        return self.stoProductContainer.stoProductList
    }
    

    internal func requestProducts(ids: [String]) -> [StoProduct]?{
        guard let products = StoAppCommunicator.sharedInstance.stoGetStoProductsByIds(ids: ids) else {
            return nil
        }
        stoProductContainer.stoProductList = products
        return stoProductContainer.stoProductList
    }
    
    
    internal func clear(){
        self.stoProductContainer.stoProductList.removeAll()
    }
}
