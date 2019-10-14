//
//  StoQueryString.swift
//  StoRetailerApp
//
//  Created by Mikhail on 04/07/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation



public class StoQueryString{
    
    private let TAG: String = "StoQueryString"
    
    // MARK: Properties
    private var server_url = "https://tk.storetail.io/x?"
    
    
    // MARK: Query String Parameters Properties
    var qspAvailableProducts: QSPAvailableProducts
    var qspClientId: QSPClientId
    var qspOptinOut: QSPOptinOut
    var qspSessionTime: QSPSessionTime
    var qspSessionPages: QSPSessionPages
    var qspTechBrowserV: QSPTechBrowserV
    var qspRetailName: QSPRetailName
    var qspRetailPage: QSPRetailPage
    var qspRetailShop: QSPRetailShop
    var qspRetailSearch: QSPRetailSearch
    var qspRetailPlacement: QSPRetailPlacement
    var qspTrackBrand: QSPTrackBrand
    var qspTrackOperation: QSPTrackOperation
    var qspTrackInsertion: QSPTrackInsertion
    var qspTrackCreative: QSPTrackCreative
    var qspTrackTime: QSPTrackTime
    var qspTrackValue: QSPTrackValue
    var qspTrackLabel: QSPTrackLabel
    var qspForcedLongitude: QSPForcedLongitude
    var qspVerifUID: QSPVerifUID
    var qspTrackAction: QSPTrackAction
    var qspTrackEvent: QSPTrackEvent
    var qspPositionObject: QSPPositionObject
    var qspProductId: QSPProductID
    var qspProductLabel: QSPProductLabel
    var qspForcedCity: QSPForcedCity
    var qspForcedLatitude: QSPForcedLatitude
    var qspPageType: QSPPageType
    
    // MARK: List of QueryStringParams
    private var queryStringParams = [QueryStringParam]()
    
    //MARK: Initialization
    
    init(){
        self.qspClientId = QSPClientId()
        self.qspOptinOut = QSPOptinOut()
        self.qspSessionTime = QSPSessionTime()
        self.qspSessionPages = QSPSessionPages()
        self.qspTechBrowserV = QSPTechBrowserV()
        self.qspRetailName = QSPRetailName()
        self.qspRetailPage = QSPRetailPage()
        self.qspRetailShop = QSPRetailShop()
        self.qspRetailSearch = QSPRetailSearch()
        self.qspRetailPlacement = QSPRetailPlacement()
        self.qspTrackBrand = QSPTrackBrand()
        self.qspTrackOperation = QSPTrackOperation()
        self.qspTrackInsertion = QSPTrackInsertion()
        self.qspTrackCreative = QSPTrackCreative()
        self.qspTrackTime = QSPTrackTime()
        self.qspTrackValue = QSPTrackValue()
        self.qspTrackLabel = QSPTrackLabel()
        self.qspTrackAction = QSPTrackAction()
        self.qspTrackEvent = QSPTrackEvent()
        self.qspProductId = QSPProductID()
        self.qspPositionObject = QSPPositionObject()
        self.qspProductLabel = QSPProductLabel()
        self.qspAvailableProducts = QSPAvailableProducts()
        self.qspForcedCity = QSPForcedCity()
        self.qspForcedLatitude = QSPForcedLatitude()
        self.qspForcedLongitude = QSPForcedLongitude()
        self.qspVerifUID = QSPVerifUID()
        self.qspPageType = QSPPageType()

        queryStringParams.append(self.qspClientId)
        queryStringParams.append(self.qspOptinOut)
        queryStringParams.append(self.qspSessionTime)
        queryStringParams.append(self.qspSessionPages)
        queryStringParams.append(self.qspTechBrowserV)
        queryStringParams.append(self.qspRetailName)
        queryStringParams.append(self.qspRetailPage)
        queryStringParams.append(self.qspRetailShop)
        queryStringParams.append(self.qspRetailSearch)
        queryStringParams.append(self.qspRetailPlacement)
        queryStringParams.append(self.qspTrackBrand)
        queryStringParams.append(self.qspTrackOperation)
        queryStringParams.append(self.qspTrackInsertion)
        queryStringParams.append(self.qspTrackCreative)
        queryStringParams.append(self.qspTrackTime)
        queryStringParams.append(self.qspTrackValue)
        queryStringParams.append(self.qspTrackLabel)
        queryStringParams.append(self.qspTrackAction)
        queryStringParams.append(self.qspTrackEvent)
        queryStringParams.append(self.qspProductId)
        queryStringParams.append(self.qspPositionObject)
        queryStringParams.append(self.qspProductLabel)
        queryStringParams.append(self.qspAvailableProducts)
        queryStringParams.append(self.qspForcedCity)
        queryStringParams.append(self.qspForcedLatitude)
        queryStringParams.append(self.qspForcedLongitude)
        queryStringParams.append(self.qspVerifUID)
        queryStringParams.append(self.qspPageType)
    }
    
    // Creates and returns a String Query
    internal func getQueryString() -> String{
        // Adds the server_rl in the beginning of the query
        var queryString: String = server_url
        
        var nbParams: Int = 0
        for qsp in queryStringParams{
            if(!qsp.value.isEmpty){
                queryString.append("&")
                queryString = queryString + qsp.name + "=" + qsp.value
                nbParams += 1
            }
        }
        return queryString
    }
    
    internal func printQuery(detailsOn : Bool){
        StoLog.d(message: "\(self.TAG): printQuery: " + getQueryString())
        var nbParams : Int = 0
        if detailsOn{
            for qsp in queryStringParams{
                if(!qsp.value.isEmpty){
                    StoLog.d(message: "\(self.TAG): printQuery: param :\(qsp.name): \(qsp.value)")
                    nbParams += 1
                }
            }
        }
        StoLog.d(message: "\(self.TAG): printQuery: nbParams: \(nbParams)")
    }
    
    internal func updateByQSP(queryStringParam qsp: QueryStringParam){
        for param in queryStringParams{
            if param.name == qsp.name{
                StoLog.i(message: "updateByQSP: name \(param.name), value \(param.value)")
                param.value = qsp.value
            }
        }
    }
    
    internal func updateByQSP(queryStringParams list: [QueryStringParam]?){
        // Verifies if the list is not null
        if list != nil{
            for param in list!{
                updateByQSP(queryStringParam: param)
            }
        }
    }
    
    internal func clear(){
        for param in queryStringParams{
            param.value = ""
        }
        StoLog.i(message: "\(self.TAG): cleared!")
    }
}
