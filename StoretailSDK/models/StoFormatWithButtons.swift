//
//  StoFormatWithButtons.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 12/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import Foundation

public class StoFormatWithButtons: StoFormat {
    
    private let TAG: String = "StoFormatWithButtons"
    
    private var productIdSelected : String?
    
    private var buttonContentList : [StoButtonContent]

    override init(formatType: StoFormatType, optionType: StoFormatOptionType) {
        buttonContentList = [StoButtonContent]()
        
        super.init(formatType: formatType, optionType: optionType)
    }
    
    public func getProducts() -> [String] {
        var products = [String]()
        for buttonContent in buttonContentList {
            products.append(contentsOf: buttonContent.productIds)
        }
        return products
    }
    
    public func getProductIdSelected() -> String? {
        if productIdSelected == nil && buttonContentList.count > 0 {
            productIdSelected = buttonContentList[0].productId
        }
        return productIdSelected
    }
    public func setProductIdSelected(productId : String) { productIdSelected = productId }
    
    public func addButtonContent(buttonContent: StoButtonContent) { buttonContentList.append(buttonContent) }
    public func getButtonContentList() -> [StoButtonContent] { return buttonContentList }
    public func setButtonContentList(list : [StoButtonContent]) {
        buttonContentList.removeAll()
        buttonContentList.append(contentsOf: list)
        
        // Sorts the list
        buttonContentList = buttonContentList.sorted(by: { (s1: StoButtonContent, s2: StoButtonContent) -> Bool in
            return s1.position < s2.position
        })
    }
}
