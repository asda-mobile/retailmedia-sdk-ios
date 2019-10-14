//
//  StoButtonContent.swift
//  StoRetailerApp
//
//  Created by Mikhail on 05/07/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import UIKit


public class StoButtonContent{
    
    //MARK: Properties
    
    // Position of the button in the Sto view
    var position: Int
    
    // Name of the button
    public internal(set) var buttonName: String
    
    // If the StoButtonContent is exclusive, the if no products from the StoButtonContent is available, don't show the view
    public internal(set) var isMandatory: Bool
    
    // List of product that can be shown in the Button
    public internal(set) var productIds: [String]
    
    // Id of the product with the highest priority
    var productId: String
    
    
    //MARK: init
    init(){
        productId = ""
        position = -1
        buttonName = ""
        isMandatory = false
        productIds = Array()
    }
    
    
    
    // MARK: Public methods

    internal func addProductId(id: String){
        self.productIds.append(id)
    }    
}
