//
//  StoConnexionUtils.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 28/11/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import SystemConfiguration


internal class StoConnexionUtils{
    
    private let TAG: String = "StoConnexionUtils"
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    
    /// Verifies if the connexion is available via Wifi or WWAN
    ///
    /// - Returns: <#return value description#>
    internal func isConnexionAvailable() -> Bool{
        StoLog.d(message: "\(self.TAG): isConnexionAvailable:")
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN{
            StoLog.d(message: "\(self.TAG): isConnexionAvailable: is available")
            return true
        }else{
            StoLog.e(message: "\(self.TAG): isConnexionAvailable: is not available")
            return false
        }
    }
    
    internal var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
    
    
    
    
    
    
}
