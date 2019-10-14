//
//  StoBanner.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 25/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import Foundation

public class StoBanner : StoFormat {
    
    private var path                    : String
    private var backgroundMobileImage   : URL?
    private var backgroundTabletImage   : URL?
    private var deeplink                : String?
    private var backgroundColor         : UIColor
    
    init(response: StoResponseBanner) {
        let randomizedString = StoFormat.randomStringWithLength(len: 5)
        
        self.path = response.path
        
        if let bgMobile = response.bg_img_mobile {
            self.backgroundMobileImage = URL(string: "\(StoFormat.EXTERNAL_URL_PROTOCOL)\(self.path)\(bgMobile)?\(randomizedString)")
        }
        
        if let bgTablet = response.bg_img_tablet {
            self.backgroundTabletImage = URL(string: "\(StoFormat.EXTERNAL_URL_PROTOCOL)\(self.path)\(bgTablet)?\(randomizedString)")
        }
        
        if let deeplink = response.option_redirection_url {
            self.deeplink = deeplink
        }
        
        if let bgColor = response.bg_color {
            self.backgroundColor = StoViewUtils.hexStringToUIColor(hex: bgColor)
        } else {
            self.backgroundColor = UIColor.white
        }
        
        super.init(formatType: .stoBanner, optionType: .redirection)
    }
    
    public func getBackgroundImageURL(isTablet: Bool) -> URL? { return isTablet ? self.backgroundTabletImage : self.backgroundMobileImage }
    
    public func getBackgroundColor() -> UIColor { return backgroundColor }
    
    public func getDeeplink() -> String? { return self.deeplink }
}
