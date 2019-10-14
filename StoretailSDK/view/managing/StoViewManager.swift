//
//  StoViewManager.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 24/07/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import UIKit


internal class StoViewManager {

    private let TAG: String = "StoViewManager"
    
    internal var viewedFormatsIds : [String]
    internal var impressedFormatsIds : [String]
    
    init() {
        viewedFormatsIds = [String]()
        impressedFormatsIds = [String]()
    }
    
    /// Add StoFormat's id to the list of impressed format
    ///
    /// - Parameter formatId: Identifier of StoFormat
    public func addImpressed(formatId : String) { impressedFormatsIds.append(formatId) }
    
    /// Check if impressed list contains StoFormat's id
    ///
    /// - Parameter formatId: Identifier of StoFormat
    public func isImpressed(formatId: String) -> Bool { return impressedFormatsIds.contains(formatId) }
    
    
    /// Add StoFormat's id to the list of viewed format
    ///
    /// - Parameter formatId: Identifier of StoFormat
    public func addViewed(formatId : String) { viewedFormatsIds.append(formatId) }
    
    /// Check if viewed list contains StoFormat's id
    ///
    /// - Parameter formatId: Identifier of StoFormat
    public func isViewed(formatId: String) -> Bool { return viewedFormatsIds.contains(formatId) }
    
    ///
    /// Remove all stored StoFormat's id
    ///
    public func clear() {
        impressedFormatsIds.removeAll()
        viewedFormatsIds.removeAll()
    }
}
