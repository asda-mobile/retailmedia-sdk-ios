//
//  StoErrorHandler.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 12/09/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation

public class StoErrorHandler{
    
    private let TAG: String = "StoErrorHandler"
    
    // StoRequestHandler for sending requests
    private var requestHandler: StoRequestHandler
    
    init(stoRequestHandler: StoRequestHandler){
        self.requestHandler = stoRequestHandler
    }
    
    
    /// Reports errors
    ///
    /// - Parameters:
    ///   - stoQueryStirng: <#stoQueryStirng description#>
    ///   - trackeEvent: <#trackeEvent description#>
    ///   - trackLabel: <#trackLabel description#>
    internal func reportError(stoQueryStirng: StoQueryString, trackeEvent: StoTrackEventValue, trackLabel: String){
        StoLog.i(message: "\(TAG): reportError")
        
        // Sets the retailName in the trackLabel
        let updatedTrackLabel = setRetailerTrackLabel(stoQueryString: stoQueryStirng, trackLabel: trackLabel)
    
        StoLog.d(message: "\(TAG): reportError: \(updatedTrackLabel)")
        
        // Verifies the type of error
        switch trackeEvent {
        case .onBuild:
            sendOnBuildError(stoQueryString: stoQueryStirng, trackLabel: updatedTrackLabel)
            break;
        case .onDeliver:
            sendOnDeliverError(stoQueryString: stoQueryStirng, trackLabel: updatedTrackLabel)
            break;
        case .onLoad:
            sendOnLoadError(stoQueryString: stoQueryStirng, trackLabel: updatedTrackLabel)
            break;
        default:
            StoLog.e(message: "\(TAG): reportError: trackEvent is not handled!")
            // Reports error
            break;
        }
    }
    
    
    /// Sets the deviceId in the trackLabel
    ///
    /// - Parameter trackLabel: <#trackLabel description#>
    /// - Returns: <#return value description#>
    /**
    private func setDeviceId(trackLabel: String) -> String{
        StoLog.i(message: "\(self.TAG): setDeviceId")
        return StoTrackerUtils.getVerifUID() + " " + trackLabel
    }**/
    
    /// Sets the retailer name in the trackLabel
    ///
    /// - Parameters:
    ///   - stoQueryString: <#stoQueryString description#>
    ///   - trackLabel: <#trackLabel description#>
    /// - Returns: <#return value description#>
    private func setRetailerTrackLabel(stoQueryString : StoQueryString, trackLabel: String) -> String{
        StoLog.i(message: "\(self.TAG): setRetailTrackLabel")
        return "\(stoQueryString.qspRetailName.value) \(trackLabel)"
    }
    
    
    /// Sets plateform's name to trackLabel
    ///
    /// - Parameter trackLabel: <#trackLabel description#>
    /// - Returns: return value description
    private func setPlateformeName(trackLabel: String) -> String{
        StoLog.i(message: "\(self.TAG): setPlateformeName")
        
        return ("ios \(trackLabel)")
    }
    
    private func setPlatformVersion(trackLabel: String) -> String{
        return "\(getPlatformVersion()) \(trackLabel)"
    }
    
    /// Return the system version
    ///
    /// - Returns: <#return value description#>
    private func getPlatformVersion() -> String{
        let systemVersion = UIDevice.current.systemVersion
        return systemVersion
    }
    
    /// Sends a request for onBuild error
    ///
    /// - Parameters:
    ///   - stoQueryString: <#stoQueryString description#>
    ///   - trackLabel: description of the error
    private func sendOnBuildError(stoQueryString: StoQueryString, trackLabel: String){
        StoLog.i(message: "\(self.TAG): sendOnBuildError call")
        
        // Updates the trackAction
        stoQueryString.qspTrackAction.value = StoTrackActionValue.err.description
        
        //Updates the trackEvent
        stoQueryString.qspTrackAction.value = StoTrackEventValue.onBuild.description
        
        // Update the trackLabel
        stoQueryString.qspTrackLabel.value = trackLabel
        
        // Sends the request
        self.requestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
        
    }
    
    /// Sends a request for onDeliver error
    ///
    /// - Parameters:
    ///   - stoQueryString: <#stoQueryString description#>
    ///   - trackLabel: description of the error
    private func sendOnDeliverError(stoQueryString: StoQueryString, trackLabel: String){
        StoLog.i(message: "\(self.TAG): sendOnDeliverError call")
        
        // Updates the trackAction
        stoQueryString.qspTrackAction.value = StoTrackActionValue.err.description
        
        //Updates the trackEvent
        stoQueryString.qspTrackAction.value = StoTrackEventValue.onDeliver.description
        
        // Update the trackLabel
        stoQueryString.qspTrackLabel.value = trackLabel
        
        // Sends the request
        self.requestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
    }

    /// Sends a request for onLoad error
    ///
    /// - Parameters:
    ///   - stoQueryString: <#stoQueryString description#>
    ///   - trackLabel: trackLabel description
    private func sendOnLoadError(stoQueryString: StoQueryString, trackLabel: String){
        StoLog.i(message: "\(self.TAG): sendOnLoadError call")
        
        // Updates the trackAction
        stoQueryString.qspTrackAction.value = StoTrackActionValue.err.description
        
        //Updates the trackEvent
        stoQueryString.qspTrackAction.value = StoTrackEventValue.onLoad.description
        
        // Update the trackLabel
        stoQueryString.qspTrackLabel.value = trackLabel
        
        // Sends the request
        self.requestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
    }
    
}
