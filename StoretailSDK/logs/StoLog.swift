//
//  StoLog.swift
//  StoRetailerApp
//
//  Created by Mikhail POGORELOV on 18/09/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation


public class StoLog {

    internal static var isDebug: Bool = false
    
    
    public static func d(message: String){
        if isDebug{
            NSLog("[DEBUG]: \(message)")
        }
    }
    
    public static func i(message: String){
        if isDebug{
            NSLog("[INFO]: \(message)")
        }
    }
    
    public static func e(message: String){
        if isDebug {
            NSLog("[ERROR]: \(message)")
        }
    }
    
    public static func w(message: String){
        if isDebug{
            NSLog("[WARNING]: \(message)")
        }
    }
    
    public static func enableLogs(){
        isDebug = true
    }
    
    public static func disableLogs(){
        isDebug = false
    }
    
}
