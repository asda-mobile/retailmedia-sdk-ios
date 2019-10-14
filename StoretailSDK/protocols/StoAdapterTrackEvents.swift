//
//  StoAdapterTrackEvents.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 12/07/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation

@objc public protocol StoAdapterTrackEvents {
    
    @objc func openProductPage(format : StoFormat)
    
    @objc func addToWishList(format : StoFormat)
    
    @objc func addToBasket(format : StoFormat)
    
    @objc func addToBasketMore(format : StoFormat)
    
    @objc func addToBasketLess(format : StoFormat)
    
    @objc func basketQuantityChange(format : StoFormat)
}
