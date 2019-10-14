//
//  StoButterflyCellProtocol.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 16/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import Foundation

protocol StoButterflyCellProtocol {
    func setButterflyFormat(stoButterfly: StoButterfly)
    func getButterflyFormat() -> StoButterfly?
    func addProductView(view: UIView)
}
