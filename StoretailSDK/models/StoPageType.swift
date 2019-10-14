//
//  StoPageType.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 12/07/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation

public enum StoPageType : CustomStringConvertible {
    
    case StoHomePage
    case StoCategoryPage
    case StoProductsListPage
    case StoSearchPage
    case StoProductPage
    case StoCheckoutPage
    case None
    
    public var description: String {
        switch self {
        case .StoHomePage:
            return "home"
        case .StoCategoryPage:
            return "shelve"
        case .StoProductsListPage:
            return "shelve"
        case .StoSearchPage:
            return "search"
        case .StoProductPage:
            return "productpage"
        case .StoCheckoutPage:
            return "checkout"
        default:
            return "none"
        }
    }
}
