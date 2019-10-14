//
//  StoEventCommunicator.swift
//  StoretailSDK
//
//  Created by Mikhail POGORELOV on 21/08/2018.
//  Copyright © 2018 Mikhail POGORELOV. All rights reserved.
//

import Foundation

public class StoEventCommunicator{
    
    private var formatsListeners = [StoFormatListener]()
    
    public static let sharedInstance = StoEventCommunicator()
    
    
    public func addStoFormatListener(stoFormatsListener : StoFormatListener){
        self.formatsListeners.append(stoFormatsListener)
    }
    
    public func removeStoFormatListener(stoFormatsListener : StoFormatListener){
        if let index = self.formatsListeners.firstIndex(where: {$0 === stoFormatsListener }) {
            self.formatsListeners.remove(at: index)
        }
    }
    
    public func getFormatsListeners() -> [StoFormatListener]{
        return self.formatsListeners
    }
    
    public func hasStoFormatsListeners() -> Bool{
        return !formatsListeners.isEmpty
    }
}
