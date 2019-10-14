//
//  StoLayoutCreator.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 12/07/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation

public protocol StoLayoutCreator {
    func createLayout(listener : StoAdapterTrackEvents, format: StoFormat, productId: String) -> UIView
}
