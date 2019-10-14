//
//  StoButterfly.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 12/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import Foundation

public class StoButterfly : StoFormatWithButtons {
    private var path : String
    
    private var backgroundMobileImage : URL?
    private var logoMobileImage : URL?
    private var backgroundTabletImage : URL?
    
    private var borderColor : UIColor
    private var backgroundColor : UIColor
    private var buttonColor : UIColor
    private var buttonSelectedColor : UIColor
    private var buttonTextColor : UIColor
    private var buttonSelectedTextColor : UIColor
    
    private var optionType : StoFormatOptionType
    private var optionFile : String
    private var optionText : String
    private var optionVideo : String
    private var optionRedirection : String
    private var optionTextColor : UIColor
    private var optionButtonColor : UIColor
    private var optionButtonImage : URL?
    
    private var hasMultiBackground : Bool
    private var multiBackgroundImage1 : URL?
    private var multiBackgroundImage2 : URL?
    private var multiBackgroundImage3 : URL?
    private var multiBackgroundImage4 : URL?
    private var multiBackgroundImage5 : URL?
    
    init(response : StoResponseButterfly) {
        let randomizedString = StoFormat.randomStringWithLength(len: 5)
        self.path = response.path
        self.optionType = response.option
        self.hasMultiBackground = response.hasMultiBackground
        
        if let backgroundMobileImage = response.backgroundMobileImage {
            self.backgroundMobileImage = URL(string: "\(StoFormat.EXTERNAL_URL_PROTOCOL)\(self.path)\(backgroundMobileImage)?\(randomizedString)")
        }
        if let logoMobileImage = response.logoMobileImage {
            self.logoMobileImage = URL(string:"\(StoFormat.EXTERNAL_URL_PROTOCOL)\(self.path)\(logoMobileImage)?\(randomizedString)")
        }
        if let backgroundTabletImage = response.backgroundTabletImage {
            self.backgroundTabletImage = URL(string:"\(StoFormat.EXTERNAL_URL_PROTOCOL)\(self.path)\(backgroundTabletImage)?\(randomizedString)")
        }
        if let borderColor = response.borderColor {
            self.borderColor = StoViewUtils.hexStringToUIColor(hex: borderColor)
        } else {
            self.borderColor = UIColor.white
        }
        if let backgroundColor = response.backgroundColor {
            self.backgroundColor = StoViewUtils.hexStringToUIColor(hex: backgroundColor)
        } else {
            self.backgroundColor = UIColor.white
        }
        if let buttonColor = response.buttonColor {
            self.buttonColor = StoViewUtils.hexStringToUIColor(hex: buttonColor)
        } else {
            self.buttonColor = UIColor.white
        }
        if let buttonSelectedColor = response.buttonSelectedColor {
            self.buttonSelectedColor = StoViewUtils.hexStringToUIColor(hex: buttonSelectedColor)
        } else {
            self.buttonSelectedColor = UIColor.white
        }
        if let buttonTextColor = response.buttonTextColor {
            self.buttonTextColor = StoViewUtils.hexStringToUIColor(hex: buttonTextColor)
        } else {
            self.buttonTextColor = UIColor.white
        }
        if let buttonSelectedTextColor = response.buttonSelectedTextColor {
            self.buttonSelectedTextColor = StoViewUtils.hexStringToUIColor(hex: buttonSelectedTextColor)
        } else {
            self.buttonSelectedTextColor = UIColor.white
        }
        
        if let optionFile = response.optionFile {
            self.optionFile = "\(StoFormat.EXTERNAL_URL_PROTOCOL)\(self.path)\(optionFile)?\(randomizedString)"
        } else {
            self.optionFile = ""
        }
        if let optionText = response.optionText {
            self.optionText = optionText
        } else {
            self.optionText = ""
        }
        if let optionVideo = response.optionVideo {
            self.optionVideo = optionVideo
        } else {
            self.optionVideo = ""
        }
        if let optionRedirection = response.optionRedirection {
            self.optionRedirection = optionRedirection
        } else {
            self.optionRedirection = ""
        }
        if let optionTextColor = response.optionTextColor {
            self.optionTextColor = StoViewUtils.hexStringToUIColor(hex: optionTextColor)
        } else {
            self.optionTextColor = UIColor.white
        }
        if let optionButtonColor = response.optionButtonColor {
            self.optionButtonColor = StoViewUtils.hexStringToUIColor(hex: optionButtonColor)
        } else {
            self.optionButtonColor = UIColor.white
        }
        if let optionButtonImage = response.optionButtonImage {
            self.optionButtonImage = URL(string:"\(StoFormat.EXTERNAL_URL_PROTOCOL)\(self.path)\(optionButtonImage)?\(randomizedString)")
        }
        
        if let multiBackgroundImage1 = response.multiBackgroundImage1 {
            self.multiBackgroundImage1 = URL(string:"\(StoFormat.EXTERNAL_URL_PROTOCOL)\(self.path)\(multiBackgroundImage1)?\(randomizedString)")
        }
        if let multiBackgroundImage2 = response.multiBackgroundImage2 {
            self.multiBackgroundImage2 = URL(string:"\(StoFormat.EXTERNAL_URL_PROTOCOL)\(self.path)\(multiBackgroundImage2)?\(randomizedString)")
        }
        if let multiBackgroundImage3 = response.multiBackgroundImage3 {
            self.multiBackgroundImage3 = URL(string:"\(StoFormat.EXTERNAL_URL_PROTOCOL)\(self.path)\(multiBackgroundImage3)?\(randomizedString)")
        }
        if let multiBackgroundImage4 = response.multiBackgroundImage4 {
            self.multiBackgroundImage4 = URL(string:"\(StoFormat.EXTERNAL_URL_PROTOCOL)\(self.path)\(multiBackgroundImage4)?\(randomizedString)")
        }
        if let multiBackgroundImage5 = response.multiBackgroundImage5 {
            self.multiBackgroundImage5 = URL(string:"\(StoFormat.EXTERNAL_URL_PROTOCOL)\(self.path)\(multiBackgroundImage5)?\(randomizedString)")
        }
        
        super.init(formatType: .stoButterfly, optionType: optionType)
    }
    
    public func getBackgroundImageURL(isTablet : Bool) -> URL? { return isTablet ? backgroundTabletImage : backgroundMobileImage }
    public func getLogoImageURL() -> URL? { return logoMobileImage }
    
    public func getBorderColor() -> UIColor { return borderColor }
    public func getBackgroundColor() -> UIColor { return backgroundColor }
    public func getButtonColor() -> UIColor { return buttonColor }
    public func getButtonSelectedColor() -> UIColor { return buttonSelectedColor }
    public func getButtonTextColor() -> UIColor { return buttonTextColor }
    public func getButtonTextSelectedColor() -> UIColor { return buttonSelectedTextColor }
    
    public func getOptionValue() -> String? {
        switch optionType {
        case .none:
            return nil
        case .redirection:
            return optionRedirection.isEmpty ? nil : optionRedirection
        case .legal:
            return optionText.isEmpty ? nil : optionText
        case .pdf:
            return optionFile.isEmpty ? nil : optionFile
        case .video:
            return optionVideo.isEmpty ? nil : optionVideo
        }
    }
    public func getOptionText() -> String { return optionText }
    public func getOptionTextColor() -> UIColor { return optionTextColor }
    public func getOptionButtonColor() -> UIColor { return optionButtonColor }
    public func getOptionButtonImage() -> URL? { return optionButtonImage }
    
    public func hasMultiBackgrounds() -> Bool { return self.hasMultiBackground }
    public func getMultiBackground(atIndex index:Int) -> URL? {
        switch index {
        case 0:
            return multiBackgroundImage1
        case 1:
            return multiBackgroundImage2
        case 2:
            return multiBackgroundImage3
        case 3:
            return multiBackgroundImage4
        case 4:
            return multiBackgroundImage5
        default:
            return nil
        }
    }
}
