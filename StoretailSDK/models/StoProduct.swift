//
//  StoProduct.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 09/08/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation

public class StoProduct{
    
    public var id: String
    public var name: String
    public var promo: Bool
    public var price: Double
    public var isAvailable: Bool
    public var quantity: Int
    
    public init() {
        id = ""
        name = ""
        promo = false
        price = 0.0
        isAvailable = false
        quantity = 0
    }
}
