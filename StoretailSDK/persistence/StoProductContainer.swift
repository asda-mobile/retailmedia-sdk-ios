//
//  StoProductContainer.swift
//  StoretailSDK
//
//  Created by Mikhail POGORELOV on 13/06/2018.
//  Copyright © 2018 Mikhail POGORELOV. All rights reserved.
//

import Foundation

internal class StoProductContainer{
    
    private let TAG: String = "StoProductContainer"
    
    
    internal var stoProductList: [StoProduct]
    
    init() {
        self.stoProductList = [StoProduct]()
    }
    
    
    internal func getProduct(byId id: String) -> StoProduct?{
        if let stoProduct:StoProduct = stoProductList.first(where: { $0.id == id}){
            return stoProduct
        }
        return nil
    }

}
