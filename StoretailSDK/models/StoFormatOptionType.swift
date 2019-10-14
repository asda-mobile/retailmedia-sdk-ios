//
//  StoFormatOptionType.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 12/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import Foundation

public enum StoFormatOptionType: String, Codable {
    case none           = "no option"
    case redirection
    case video
    case pdf
    case legal
}
