//
//  StoButterflyViewProtocol.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 17/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import Foundation

protocol StoButterflyViewProtocol : class {
    func buttonCliked(cell: StoButterflyCellProtocol, productId: String)
}
