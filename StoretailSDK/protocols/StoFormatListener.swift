//
//  StoFormatListener.swift
//  StoretailSDK
//
//  Created by Mikhail POGORELOV on 21/08/2018.
//  Copyright © 2018 Mikhail POGORELOV. All rights reserved.
//

import Foundation

public protocol StoFormatListener : class {
    
    func onStoFormatsReceived(formatsList: [StoFormat], identifier: String?)
    
    func onStoFailure(message: String, identifier: String?)
}
