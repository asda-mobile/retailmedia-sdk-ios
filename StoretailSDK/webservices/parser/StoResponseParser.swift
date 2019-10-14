//
//  StoResponseParser.swift
//  StoRetailerApp
//
//  Created by Mikhail on 05/07/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import UIKit


/// Contains methods for parsing server responses.
internal class StoResponseParser {

    private let TAG: String = "StoResponseParser"

    private let stoButterflyParserLogic : StoButterflyParserLogic
    private let stoVignetteParserLogic : StoVignetteParserLogic
    private let stoBannerParserLogic : StoBannerParserLogic
    
    init() {
        stoButterflyParserLogic = StoButterflyParserLogic()
        stoVignetteParserLogic = StoVignetteParserLogic()
        stoBannerParserLogic = StoBannerParserLogic()
    }
    
    internal func getStoFormats(response: StoResponseLod) -> [StoFormat] {
        let stoFormatParser = StoFormatParser(response: response)
        var stoFormats: [StoFormat] = Array()
        
        stoFormatParser.setParser(parser: self.stoButterflyParserLogic)
        stoFormats.append(contentsOf: stoFormatParser.parse())
        
        stoFormatParser.setParser(parser: self.stoVignetteParserLogic)
        stoFormats.append(contentsOf: stoFormatParser.parse())
        
        stoFormatParser.setParser(parser: self.stoBannerParserLogic)
        stoFormats.append(contentsOf: stoFormatParser.parse())
        
        stoFormats.append(contentsOf: stoFormatParser.parseCustom())
        
        StoLog.d(message:"\(TAG): getStoFormats: retrived formats size: \(stoFormats.count)")
        
        return stoFormats
    }
}
