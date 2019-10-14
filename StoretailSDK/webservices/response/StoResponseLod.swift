//
//  StoResponseLod.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 18/06/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import AnyCodable

internal struct StoResponseLod : Codable {
    let status, vuid : String
    let creatives : StoResponseCreative
}

internal struct StoResponseCreative : Codable {
    let placements: StoResponsePlacement?
    let data: StoResponseData?
    let unexposed : [String: StoResponseUnexposed]?
    
    internal func getNoExpParams() -> [[QueryStringParam]] {
        var queryStringParamList: [[QueryStringParam]] = [[QueryStringParam]]()
        
        if let noexp = unexposed {
            for (_, value) in noexp {
                var queryStringParams: [QueryStringParam] = [QueryStringParam]()
                
                queryStringParams.append(QSPTrackCreative(value: value.tc))
                queryStringParams.append(QSPTrackBrand(value: value.tb))
                queryStringParams.append(QSPTrackInsertion(value: value.ti))
                queryStringParams.append(QSPTrackOperation(value: value.to))
                
                queryStringParamList.append(queryStringParams)
            }
        }
        return queryStringParamList
    }
}

internal struct StoResponsePlacement : Codable {
    let bf : [StoGenericFormat<StoResponseButterfly>]
    let vi : [StoGenericFormat<StoResponseBanner>]
    let ba : [StoGenericFormat<StoResponseBanner>]
    let custom : [StoGenericFormat<[String:AnyCodable]>]
    
    init(from decoder: Decoder) {
        var bfArray : [StoGenericFormat<StoResponseButterfly>] = []
        var viArray : [StoGenericFormat<StoResponseBanner>] = []
        var baArray : [StoGenericFormat<StoResponseBanner>] = []
        var customArray : [StoGenericFormat<[String:AnyCodable]>] = []
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Butterfly Parsing
            do {
                if let mbfObject = try container.decodeIfPresent(StoGenericFormat<StoResponseButterfly>.self, forKey: .bf) {
                    bfArray.append(mbfObject)
                }
            } catch {
                if var mbfDatas = try? container.nestedUnkeyedContainer(forKey: .bf) {
                    while !mbfDatas.isAtEnd {
                        if let mbfObject = try? mbfDatas.decode(StoGenericFormat<StoResponseButterfly>.self) {
                            bfArray.append(mbfObject)
                        }
                    }
                }
            }
            
            // Vignette parsing
            do {
                if let viObject = try container.decodeIfPresent(StoGenericFormat<StoResponseBanner>.self, forKey: .vi) {
                    viArray.append(viObject)
                }
            } catch {
                if var viDatas = try? container.nestedUnkeyedContainer(forKey: .vi) {
                    while !viDatas.isAtEnd {
                        if let viObject = try? viDatas.decode(StoGenericFormat<StoResponseBanner>.self) {
                            viArray.append(viObject)
                        }
                    }
                }
            }
            
            // Banner parsing
            do {
                if let baObject = try container.decodeIfPresent(StoGenericFormat<StoResponseBanner>.self, forKey: .ba) {
                    baArray.append(baObject)
                }
            } catch {
                if var baDatas = try? container.nestedUnkeyedContainer(forKey: .ba) {
                    while !baDatas.isAtEnd {
                        if let baObject = try? baDatas.decode(StoGenericFormat<StoResponseBanner>.self) {
                            baArray.append(baObject)
                        }
                    }
                }
            }
        } catch {
            StoLog.e(message:"Parser : Impossible to decode StoResponsePlacement object")
        }
        
        do {
            let container = try decoder.container(keyedBy: FormatNameKey.self)
            // Custom Parsing
            for key in container.allKeys {
                if key.stringValue != "BF" && key.stringValue != "VI" && key.stringValue != "BA" {
                    do {
                        if var customObject = try container.decodeIfPresent(StoGenericFormat<[String:AnyCodable]>.self, forKey: key) {
                            customObject.formatName = key.stringValue
                            customArray.append(customObject)
                        }
                    } catch {
                        if var mbfDatas = try? container.nestedUnkeyedContainer(forKey: key) {
                            while !mbfDatas.isAtEnd {
                                if var customObject = try? mbfDatas.decode(StoGenericFormat<[String:AnyCodable]>.self) {
                                    customObject.formatName = key.stringValue
                                    customArray.append(customObject)
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            StoLog.e(message:"Parser : Impossible to decode StoResponsePlacement object")
        }
        
        bf = bfArray
        vi = viArray
        ba = baArray
        custom = customArray
    }
    
    struct FormatNameKey: CodingKey {
        var stringValue: String
        var intValue: Int?
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        init?(intValue: Int) {
            self.stringValue = "\(intValue)";
            self.intValue = intValue
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case bf = "BF"
        case vi = "VI"
        case ba = "BA"
    }
}

struct StoGenericFormat <T:Codable> : Codable {
    let tb : String
    let to : String
    let ti : String
    let tc : String
    let values : T
    var formatName : String?
    
    internal func getQSP(type: String) -> [QueryStringParam]{
        var queryStringParams: [QueryStringParam] = Array()
        
        let qspTB = QSPTrackBrand(value: tb)
        queryStringParams.append(qspTB)
        
        let qspTO = QSPTrackOperation(value: to)
        queryStringParams.append(qspTO)
        
        let qspTC = QSPTrackCreative(value: tc)
        queryStringParams.append(qspTC)
        
        let qspTI = QSPTrackInsertion(value: ti)
        queryStringParams.append(qspTI)
        
        let qspRP = QSPRetailPlacement(value: type)
        queryStringParams.append(qspRP)
        
        return queryStringParams
    }
}

struct StoResponseBanner : Codable {
    
    var path : String
    
    var bg_img_mobile : String?
    var bg_img_tablet : String?
    var option_redirection_url : String?
    var bg_color : String?
    
    enum CodingKeys : String, CodingKey {
        case path
        case bg_img_mobile
        case bg_img_tablet
        case option_redirection_url
        case bg_color
    }
}

struct StoResponseButterfly : Codable {
    
    var path : String
    
    var backgroundMobileImage : String?
    var logoMobileImage : String?
    var backgroundTabletImage : String?
    
    var borderColor : String?
    var backgroundColor : String?
    var buttonColor : String?
    var buttonSelectedColor : String?
    var buttonTextColor : String?
    var buttonSelectedTextColor : String?
    
    var option : StoFormatOptionType
    var optionFile : String?
    var optionText : String?
    var optionVideo : String?
    var optionRedirection : String?
    var optionTextColor : String?
    var optionButtonColor : String?
    var optionButtonImage : String?
    
    var hasMultiBackground : Bool
    var multiBackgroundImage1 : String?
    var multiBackgroundImage2 : String?
    var multiBackgroundImage3 : String?
    var multiBackgroundImage4 : String?
    var multiBackgroundImage5 : String?
    
    var products : [[AnyCodable]]?
    
    enum CodingKeys : String, CodingKey {
        case path
        case backgroundMobileImage = "bg_img_mobile"
        case logoMobileImage = "logo_img_mobile"
        case backgroundTabletImage = "bg_img_tablet"
        
        case borderColor = "border_color"
        case backgroundColor = "bg_color"
        case buttonColor = "button_color"
        case buttonSelectedColor = "button_color_selected"
        case buttonTextColor = "button_txt_color"
        case buttonSelectedTextColor = "button_txt_color_selected"
        
        case option
        case optionFile = "option_file"
        case optionText = "option_text"
        case optionVideo = "option_video_link"
        case optionRedirection = "option_redirection_url"
        case optionTextColor = "option_txt_color"
        case optionButtonColor = "option_button_color"
        case optionButtonImage = "option_button_img"
        
        case hasMultiBackground = "option_multi_bg"
        case multiBackgroundImage1 = "multi_bg_img_01"
        case multiBackgroundImage2 = "multi_bg_img_02"
        case multiBackgroundImage3 = "multi_bg_img_03"
        case multiBackgroundImage4 = "multi_bg_img_04"
        case multiBackgroundImage5 = "multi_bg_img_05"
        
        case products
    }
}

struct StoResponseData : Codable {
    
    let loaded: Bool
    let cid : String
    let uid : String
    let sid : String
}

struct StoResponseUnexposed : Codable {
    
    let tb : String
    let to : String
    let ti : String
    let tc : String
    let re : [String]
}
