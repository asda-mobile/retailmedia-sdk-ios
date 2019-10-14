//
//  StoTrackerHelper.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 13/07/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import UIKit

public class StoTrackerHelper{
    
    private let TAG: String = "StoTrackerHelper"
    
    // MARK: Private properties
    // List of formats for which the quantity of available products has been sent
    private var availProductsSent: [String] = [String]()
    
    // StoViewManager manages updates of view
    private var stoViewManager: StoViewManager
    
    // StoPersistanceHandler
    private var stoPersistanceHandler: StoPersitanceHandler
    
    // StoConnexionUtils
    private var stoConnexionUtils: StoConnexionUtils
    
    
    // Number of session pages
    private var nbSessionPages: Int = 0
    
    // Previous page
    /**
     Note: Used for updating the number of session pages,
     If the previousPage equals the current page, the number of session pages won't be updated
    */
    private var previousPage: String = ""
    
    // List of already decorated products
    private var updatedStoViews: [String] = [String]()
    
    // The delay of the session
    private let SESSION_TIME: Int = 30 * 60 // 30 minutes
    
    // Time of the last StoTracker action call
    private var lastActionCallTime: TimeInterval = 0
    
    // Current session time
    private var currentSessionTime: TimeInterval = 0
    
    // Start Track time
    private var startTrackTime:Double = 0.0
    
    
    // The delay of the verifUID life
    private let VERIF_UID_LIFE: Int = 60 * 60 * 24 * 45 // 1 hour * 45 days
    
    // Time of the last verif id generation
    private let lastVerifUidGeneratedTime: TimeInterval = 0
    
    // Page used by lod track action
    internal var stoPageType: StoPageType = StoPageType.None
    
    init(){
        self.stoViewManager = StoViewManager()
        self.stoPersistanceHandler = StoPersitanceHandler()
        self.stoConnexionUtils = StoConnexionUtils()
    }
    
    public func getStoPageType() -> StoPageType { return stoPageType }
    public func setStoPageType(stoPageType : StoPageType) { self.stoPageType = stoPageType }
    
    
    /// Adds the id of the updated to the list
    ///
    /// - Parameter id: <#id description#>
    internal func addUpdatedView(stringID id: String){
        self.updatedStoViews.append(id)
    }
    
    /// Returns true if the view has been updated already
    ///
    /// - Parameter id: <#id description#>
    /// - Returns: <#return value description#>
    internal func isUpdated(stringID id: String) -> Bool{
        return self.updatedStoViews.contains(id)
    }
    
    internal func isAvailProdSent(uniqueID id: String) -> Bool{
        return self.availProductsSent.contains(id)
    }
    
    internal func addAvailProductsSent(uniqueID id: String){
        self.availProductsSent.append(id)
    }
    
    internal func addViewedObject(stoFormatId: String){
        self.stoViewManager.addViewed(formatId: stoFormatId)
    }
    
    internal func addImpressedObject(stoFormatId: String){
        self.stoViewManager.addImpressed(formatId: stoFormatId)
    }
    
    internal func isImpressed(stoFormatId: String) -> Bool{
        return self.stoViewManager.isImpressed(formatId: stoFormatId)
    }
    
    internal func isViewed(stoFormatId: String) -> Bool{
        return self.stoViewManager.isViewed(formatId: stoFormatId)
    }
    
    /// Increments the number of visited pages
    private func incSessionPages(){
        self.nbSessionPages += 1
    }
    
    /// Resets the number of session pages
    private func resetSessionPages(){
        self.nbSessionPages = 0
    }
    
    /// Returns the number of visited pages during the session
    ///
    /// - Parameter retailPage: <#retailPage description#>
    /// - Returns: <#return value description#>
    internal func getSessionPages(retailPage: String) -> String{
        StoLog.i(message: "\(self.TAG): getSessionPages: retailPage: \(retailPage), previous page \(previousPage)")
        
        // Verifies if the retailPage is not null
        if retailPage == ""{
            StoLog.e(message: "\(self.TAG): getSessionPages: retail page is empty")
            return "0"
        }
        
        // Verifies if the current page equals the previous one
        if retailPage != previousPage{
            StoLog.i(message: "\(self.TAG): getSessionPages: retail page is different to the privious one")
            self.incSessionPages()
        }
        
        //Sets the previous page
        previousPage = retailPage
        
        return String(self.nbSessionPages)
    }
    
    /// Updates the session time
    internal func getSessionTime() -> String {
        StoLog.i(message: "\(self.TAG): udpateSessionTime: ")
        
        // Gets the current time
        let currentTime: Double = NSDate().timeIntervalSince1970
        
        // Verifies if the difference between the time of the current call, and the last call is less than SESSION_TIME
        if (currentTime - self.lastActionCallTime) <= Double(self.SESSION_TIME){
            StoLog.d(message: "\(self.TAG): updateSessionTime: diff: \((currentTime - self.lastActionCallTime))")
            
            // Sets the currentSessionTime
            self.currentSessionTime = self.currentSessionTime + (currentTime - self.lastActionCallTime)
            
        }else{
            // Resets the number of session pages
            self.resetSessionPages()
            
            // Resets the sessionTime
            self.currentSessionTime = 0
        }
        
        let ms = Int(currentSessionTime * 1000)
        
        // Converts the currentSessionTime to String
        let currentSessionTimeString = String(ms)
        
        StoLog.d(message: "\(self.TAG): updateSessionTime: sessionTime \(currentSessionTimeString)")
        
        // Sets the time of the last action call
        self.lastActionCallTime = currentTime
        
        // Saves the time of the last action call
        self.stoPersistanceHandler.setLastActionCallTime(lastActionCallTime: self.lastActionCallTime)
        
        return currentSessionTimeString
    }
    
    internal func startTimeTrack(){
        // Sets the startTrack time
        self.startTrackTime = NSDate().timeIntervalSince1970 * 1000
    }
    
    internal func getTrackTime() -> String{
        // Calculates the trackTime
        let trackTime = Int((NSDate().timeIntervalSince1970 * 1000) - self.startTrackTime)
        return String(trackTime)
    }
    
    ///  Return unique ID
    ///
    /// - Returns:
    internal func getVerifUID() -> String{
        // Verifies if the verifUID is expired
        if isVerifUIDExpired(){
            StoLog.d(message: "\(self.TAG): getVerifUID: verifUID is expired")
            return updateVerifUID()
        }else{
            if let lastVerifUID = getLastVerifUID(){
                    StoLog.d(message: "\(self.TAG): getVerifUID: returns last verif uid \(lastVerifUID)")
                    return lastVerifUID
            }else{
                StoLog.d(message: "\(self.TAG): getVerifUID: updatesVerifUID")
                return updateVerifUID()
            }
        }
    }
    
    private func isVerifUIDExpired() -> Bool{
        // Gets the current time
        let currentTime = NSDate().timeIntervalSince1970
        if let lastActionCall = self.stoPersistanceHandler.getLastActionCallTime(){
            StoLog.d(message: "isVerifUIDExpired: last call: \(currentTime - lastActionCall) \(!((currentTime - lastActionCall) <= Double(self.VERIF_UID_LIFE)))")
            return !((currentTime - lastActionCall) <= Double(self.VERIF_UID_LIFE))
        }
        return false
    }
    
    
    private func getLastVerifUID() -> String?{
        if let lastVerifUID = stoPersistanceHandler.getVerifUID(){
            return lastVerifUID
        }
        return nil
    }
    
    /// Generates a new verifUID and saves it
    ///
    /// - Returns: <#return value description#>
    private func updateVerifUID() -> String{
        // Generates the verif UID
        let uid = StoTrackerUtils.getRandomizedUID()
        // Saves the generated uid
        self.stoPersistanceHandler.setVerifUID(verifUID: uid)
        StoLog.i(message: "\(self.TAG): updateVerifUID: generated \(uid)")
        return uid
    }
    
    internal func isConnexionAvailable() -> Bool {
        return self.stoConnexionUtils.isConnexionAvailable()
    }
    
    internal func removeFormats(){
        self.stoViewManager.clear()
        self.availProductsSent.removeAll()
    }
}
