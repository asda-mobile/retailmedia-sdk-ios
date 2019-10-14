//
//  StoTrackActionValue.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 24/07/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation


public enum StoTrackActionValue{
    
    case lod
    case clk
    case act
    case imp
    case fp
    case view
    case qty
    case buy
    case abk
    case abp
    case bsk
    case avail
    case noexp
    case err
    
    var description : String {
        switch self {
            case .lod: return "lod"
            case .clk: return "clk"
            case .act: return "act"
            case .imp: return "imp"
            case .fp: return "fp"
            case .view: return "view"
            case .qty: return "qty"
            case .buy: return "buy"
            case .abk: return "abk"
            case .abp: return "abp"
            case .bsk: return "bks"
            case .avail: return "avail"
            case .noexp: return "noexp"
            case .err: return "err"
        }
    }
}
