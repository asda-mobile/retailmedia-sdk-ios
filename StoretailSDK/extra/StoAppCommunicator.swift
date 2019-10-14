//
//  StoAppCommunicatorDelegate.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 08/12/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation


public class StoAppCommunicator{
    // Singleton pattern
    public static let sharedInstance = StoAppCommunicator()
    
    // StoRetrieverDelegate
    private var stoRetrieverDelegate: StoRetrieverDelegate?
    
    public func setRetrieverDelegate(retrieverDelegate: StoRetrieverDelegate){
        StoLog.d(message: "StoAppCommunicatorDelegate: setRetrieverDelegate")
        self.stoRetrieverDelegate = retrieverDelegate
    }
    
    internal func stoGetStoProductById(productId: String) -> StoProduct?{
        return self.stoRetrieverDelegate?.stoGetStoProductById(productId:productId)
    }
    
    internal func stoGetStoProductsByIds(ids: [String]) -> [StoProduct]?{
        return self.stoRetrieverDelegate?.stoGetStoProductsByIds(ids: ids)
    }
    
    internal func stoGetBasketProducts() -> [StoProduct]? {
        return self.stoRetrieverDelegate?.stoGetBasketProducts()
    }
}
