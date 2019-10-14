//
//  StoKeyValuePersistenceMananger.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 08/01/2018.
//  Copyright © 2018 Mikhail POGORELOV. All rights reserved.
//

import Foundation

internal class StoKeyValuePersistenceHandler{
    
    private let TAG: String  = "StoKeyValuePersistenceHandler"
    
    // VerifUID Key
    private let verifUID_key: String = "verifUID_key"
    
    // LastActionCallTime Key
    private let lastActionCallTime_key: String = "lastActionCallTime_key"
    
    
    // UsersDefaults
    private let defaults: UserDefaults
    
    init(){
        self.defaults = UserDefaults.standard
    }
    
    
    internal func setVerifUID(verifUID: String){
        StoLog.d(message: "\(self.TAG): setVerifUID: verifUID: \(verifUID)")
        defaults.set(verifUID, forKey: self.verifUID_key)
    }
    
    internal func getVerifUID() -> String?{
        StoLog.d(message: "\(self.TAG): getVerifUID")
        
        if let verifUID = defaults.string(forKey: self.verifUID_key){
            return verifUID
        }
        return nil
    }
    
    internal func setLastActionCallTime(lastActionCallTime: Double){
        StoLog.d(message: "\(self.TAG): setLastActionCallTime: \(lastActionCallTime)")
        defaults.set(lastActionCallTime, forKey: lastActionCallTime_key)
    }
    
    internal func getLastActionCalltime() -> Double?{
        StoLog.d(message: "\(self.TAG): getLastActionCallTime")
        return defaults.double(forKey: self.lastActionCallTime_key)
    }
    
    
    
    
    
}
