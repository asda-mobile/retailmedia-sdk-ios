//
//  StoTrackEventValue.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 24/07/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import UIKit



public enum StoTrackEventValue{
    
    case OpenPdp
    case MoreInfo
    case Delete
    
    case QuantityChange
    case QuantityMore
    case QuantityLess
    
    case BrowsePdtc
    
    case ConfirmDelete
    case CancelDelete
    
    case AddToList
    case AbkBtn
    
    case cta
    
    case openVideo
    case openPdf
    
    case onBuild
    case onLoad
    case onDeliver
    case onSetup
    
    var description : String {
        switch self {
            case .OpenPdp: return "open-pdp"
            case .MoreInfo: return "MoreInfo"
            case .Delete: return "Delete"
            case .QuantityChange: return "qty-chge"
            case .QuantityMore: return "qty-more"
            case .QuantityLess: return "qty-less"
            case .BrowsePdtc: return "browse-pdct"
            case .ConfirmDelete: return "ConfirmDelete"
            case .CancelDelete: return "CancelDelete"
            case .AddToList: return "add-list"
            case .AbkBtn: return "abk-btn"
            case .cta: return "cta"
            case .onBuild: return "onBuild"
            case .onLoad: return "onLoad"
            case .onDeliver: return "onDeliver"
            case .onSetup: return "onSetup"
            case .openVideo: return "video-play"
            case .openPdf: return "dwnld-pdf"
        }
    }
}
