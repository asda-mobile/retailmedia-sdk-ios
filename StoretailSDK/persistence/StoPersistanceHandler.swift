//
//  StoPersistanceHandler.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 08/01/2018.
//  Copyright © 2018 Mikhail POGORELOV. All rights reserved.
//

import Foundation


internal class StoPersitanceHandler{
    
    private let TAG: String = "StoPersistenceHandler"
    
    private var stoKeyValuePersistenceHandler: StoKeyValuePersistenceHandler
    
    
    init(){
        self.stoKeyValuePersistenceHandler = StoKeyValuePersistenceHandler()
    }
    

    
    internal func getVerifUID() -> String?{
        StoLog.d(message: "\(self.TAG): getVerifUID")
        return self.stoKeyValuePersistenceHandler.getVerifUID()
    }
    
    internal func setVerifUID(verifUID: String){
        StoLog.d(message: "\(self.TAG): getVerifUID: \(verifUID) ")
        self.stoKeyValuePersistenceHandler.setVerifUID(verifUID: verifUID)
    }
    
    internal func setLastActionCallTime(lastActionCallTime: Double){
        StoLog.d(message: "\(self.TAG): setLastActionCallTime")
        self.stoKeyValuePersistenceHandler.setLastActionCallTime(lastActionCallTime: lastActionCallTime)
    }

    internal func getLastActionCallTime() -> Double?{
        StoLog.d(message: "\(self.TAG): getLastActionCallTime")
        return self.stoKeyValuePersistenceHandler.getLastActionCalltime()
    }
    
    
}

