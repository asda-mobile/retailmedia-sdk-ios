//
//  QueryStringParams.swift
//  StoRetailerApp
//
//  Created by Mikhail on 03/07/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

//Class contains all parameters of the QueryString


import Foundation

// MARK: QueryStringParam
internal class QueryStringParam{
    
    internal var name: String
    internal var value: String;
    
    init(qspName: String, value: String){
        self.name = qspName
        self.value = value
    }
    
    init(qspName: String){
        name = qspName
        value = ""
    }
    
    internal func print(){
        StoLog.d(message: "name:\(name), value:\(value)")
    }
}

// MARK: Query String Parameters
internal class QSPClientId: QueryStringParam{

    init(value: String){
        super.init(qspName: "ci",value: value)
    }
    
    init(){
        super.init(qspName: "ci")
    }
    
}

internal class QSPForcedCity: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "fc",value: value)
    }
    
    init(){
        super.init(qspName: "fc")
    }
}


internal class QSPForcedLatitude: QueryStringParam{
    init(value: String){
        super.init(qspName: "lt",value: value)
    }
    
    init(){
        super.init(qspName: "lt")
    }
}


internal class QSPForcedLongitude: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "lg",value: value)
    }
    
    init(){
        super.init(qspName: "lg")
    }
    
}

internal class QSPPositionObject: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "po",value: value)
    }
    
    init(){
        super.init(qspName: "po")
    }
}

internal class QSPOptinOut: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "in",value: value)
    }
    
    init(){
        super.init(qspName: "in")
    }
}



internal class QSPProductID: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "pi",value: value)
    }
    
    init(){
        super.init(qspName: "pi")
    }
}

internal class QSPProductLabel: QueryStringParam{
    
    
    init(value: String){
        super.init(qspName: "pl",value: value)
    }
    
    init(){
        super.init(qspName: "pl")
    }
}


internal class QSPAvailableProducts: QueryStringParam{

    init(value: String){
        super.init(qspName: "ap",value: value)
    }
    
    init(){
        super.init(qspName: "ap")
    }
}


internal class QSPRetailName: QueryStringParam{

    init(value: String){
        super.init(qspName: "rn",value: value)
    }
    
    init(){
        super.init(qspName: "rn")
    }
    
}


internal class QSPRetailPage: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "rp",value: value)
    }
    
    init(){
        super.init(qspName: "rp")
    }
}


internal class QSPRetailPlacement: QueryStringParam{

    init(value: String){
        super.init(qspName: "re",value: value)
    }
    
    init(){
        super.init(qspName: "re")
    }
}

internal class QSPRetailSearch: QueryStringParam{
   
    init(value: String){
        super.init(qspName: "rk",value: value)
    }
    
    init(){
        super.init(qspName: "rk")
    }
}

internal class QSPRetailShop: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "rs",value: value)
    }
    
    init(){
        super.init(qspName: "rs")
    }
}


internal class QSPSessionPages: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "up",value: value)
    }
    
    init(){
        super.init(qspName: "up")
    }
}


internal class QSPSessionTime: QueryStringParam{

    init(value: String){
        super.init(qspName: "ut",value: value)
    }
    
    init(){
        super.init(qspName: "ut")
    }
}

internal class QSPTechBrowserV: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "techBrowserV",value: value)
    }
    
    init(){
        super.init(qspName: "techBrowserV")
    }
    
}


internal class QSPTechScreen: QueryStringParam{

    init(value: String){
        super.init(qspName: "ts",value: value)
    }
    
    init(){
        super.init(qspName: "ts")
    }
}

internal class QSPTechWindow: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "tw",value: value)
    }
    
    init(){
        super.init(qspName: "tw")
    }
}

internal class QSPTrackAction: QueryStringParam{
 
    init(value: String){
        super.init(qspName: "ta",value: value)
    }
    
    init(){
        super.init(qspName: "ta")
    }
}

internal class QSPTrackBrand: QueryStringParam{

    init(value: String){
        super.init(qspName: "tb",value: value)
    }
    
    init(){
        super.init(qspName: "tb")
    }
}

internal class QSPTrackCreative: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "tc",value: value)
    }
    
    init(){
        super.init(qspName: "tc")
    }
}


internal class QSPTrackEvent: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "te",value: value)
    }
    
    init(){
        super.init(qspName: "te")
    }
}

internal class QSPTrackFrom: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "tf",value: value)
    }
    
    init(){
        super.init(qspName: "tf")
    }
}

internal class QSPTrackGoal: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "tg",value: value)
    }
    
    init(){
        super.init(qspName: "tg")
    }
}

internal class QSPTrackInsertion: QueryStringParam{

    init(value: String){
        super.init(qspName: "ti",value: value)
    }
    
    init(){
        super.init(qspName: "ti")
    }
}

internal class QSPTrackLabel: QueryStringParam{
 
    init(value: String){
        super.init(qspName: "tl",value: value)
    }
    
    init(){
        super.init(qspName: "tl")
    }
}

internal class QSPTrackOperation: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "to",value: value)
    }
    
    init(){
        super.init(qspName: "to")
    }
}

internal class QSPTrackStep: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "tp",value: value)
    }
    
    init(){
        super.init(qspName: "tp")
    }
}

internal class QSPTrackTime: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "tt",value: value)
    }
    
    init(){
        super.init(qspName: "tt")
    }
}

internal class QSPTrackValue: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "tn",value: value)
    }
    
    init(){
        super.init(qspName: "tn")
    }
}


internal class QSPTrackVisibilty: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "tv",value: value)
    }
    
    init(){
        super.init(qspName: "tv")
    }
}

internal class QSPTrackZone: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "tz",value: value)
    }
    
    init(){
        super.init(qspName: "tz")
    }
}

internal class QSPVerifUID: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "vf",value: value)
    }
    
    init(){
        super.init(qspName: "vf")
    }
}

internal class QSPPageType: QueryStringParam{
    
    init(value: String){
        super.init(qspName: "pt",value: value)
    }
    
    init(){
        super.init(qspName: "pt")
    }
}

