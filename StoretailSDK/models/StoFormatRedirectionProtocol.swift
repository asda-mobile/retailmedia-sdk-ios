//
//  StoRedirectFormat.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 24/07/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation

public protocol StoFormatRedirectionProtocol {
    func getBackgroundImageURL() -> String
    func getDeeplink() -> String
}
