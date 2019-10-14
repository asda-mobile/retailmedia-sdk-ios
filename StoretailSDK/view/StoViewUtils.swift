//
//  ViewUtils.swift
//  StoRetailerApp
//
//  Created by Mikhail on 27/06/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import UIKit

internal class StoViewUtils{
    
    private static let TAG: String = "StoViewUtils"
    
    
    // Default border width
    private static let DF_BORDER_WIDTH: Int = 3
    
    // Default corner radius
    private static let DF_CORNER_RADIUS: Int = 9
    
    
    // MARK: Private properties
    
    // Default ratio of StoMBFButterflies' button height view/button
    internal static let DF_MBF_BUTTON_RATIO_H : Float = 1 / 3
    
    // Default ratio of StoMBFButterflies' button width view/button
    internal static let DF_MBF_BUTTON_RATIO_W : Float = 340 / 1242
    
    // Default MBFButterflyColor
    private static let DF_MBF_COLOR: UIColor = UIColor.white
    
    
    //MARK: public static methods
    
    
    /// <#Description#>
    /// Sets height of the view
    /// - Parameters:
    ///   - height: <#height description#>
    ///   - view: <#view description#>
    internal static func setHeight(height: CGFloat, view: UIView){
        view.frame.size.height = CGFloat(height)
    }
    
    
    internal static func getImageViewSize(heightOfView: Int, widthOfView: Int) -> (Int,Int){
        let width = widthOfView / 3
        return (heightOfView, width)
    }
    
    internal static func getImageViewCGRect(viewHeight: Int, viewWidth: Int, isMiddle: Bool) -> CGRect{
        StoLog.d(message: "\(self.TAG): getImageViewCGRect: viewWidth: \(viewWidth), viewHeight: \(viewHeight)")
        
        // Calculates the image size
        let x = self.getImageViewSize(heightOfView: viewHeight, widthOfView: viewWidth)
        
        let imageViewWidth = x.1
        let imageViewHeight = x.0
        
        // Calculates middle position for the image view
        if !isMiddle{
            let xPosition = ((viewWidth / 3) / 2) - imageViewWidth / 2
            let yPosition = 0
            
            // Loads the image into the imageView
            StoLog.d(message: "\(self.TAG): getImageViewCGRect: !isMiddle: width:\(imageViewWidth), height: \(imageViewHeight)")
            return CGRect(x: Int(xPosition), y: Int(yPosition), width: imageViewWidth, height: Int(imageViewHeight))
            // Calculates the left position for the image view
        }else{
            let xPosition = viewWidth / 2 - imageViewWidth / 2
            let yPosition = 0
            StoLog.d(message: "\(self.TAG): getImageViewCGRect: idMiddle: width:\(imageViewWidth), height: \(imageViewHeight)")
            
            return CGRect(x: Int(xPosition), y: Int(yPosition), width: imageViewWidth, height: Int(imageViewHeight))
        }
    }
    
    /// <#Description#>
    /// Calculates the CGRect for the button, depending on it's position in the list and the super view width
    /// - Parameters:
    ///   - number: <#number description#>
    ///   - nbButtons: <#nbButtons description#>
    ///   - widthOfView: <#widthOfView description#>
    /// - Returns: <#return value description#>
    internal static func getButtonFrame(buttonPosition position: Int, numberOfButtons nbButtons: Int, heightOfView: Int, widthOfView: Int) -> CGRect?{
        
        //StoLog.d(message: "\(self.TAG): getButtonFrame: heightOfView: \(heightOfView), widthOfView: \(widthOfView)")
        
        let btnWidth = self.getButtonWidth(viewWidth: widthOfView, ratio: DF_MBF_BUTTON_RATIO_W)
        let btnHeight = self.getButtonHeight(viewHeight: heightOfView, ratio: DF_MBF_BUTTON_RATIO_H)
        
        let verticalSpacing = self.getButtonVerticalSpacing(viewHeight: heightOfView,buttonHeight: btnHeight, nbButtons: nbButtons)
        let horizontalSpacing = self.getButtonHorizontalSpacing(viewWidth: widthOfView, buttonWidth: btnWidth)
        
        /**
        StoLog.d(message: "\(self.TAG): getButtonFrame: buttonWidth: \(btnWidth)")
        StoLog.d(message: "\(self.TAG): getButtonFrame: buttonHeight: \(btnHeight)")
        StoLog.d(message: "\(self.TAG): getButtonFrame: verticalSpacing: \(verticalSpacing)")
        StoLog.d(message: "\(self.TAG): getButtonFrame: horizontalSpacing: \(horizontalSpacing)")
        **/
        
        // If the view must have only 2 buttons
        if nbButtons == 2{
            StoLog.d(message: "\(self.TAG): getButtonFrame: 2 buttons positon: \(position)")
            switch position {
            case 1:
                return CGRect(x: widthOfView / 3 + horizontalSpacing, y: verticalSpacing, width: btnWidth, height: btnHeight)
            case 2:
                return CGRect(x: widthOfView / 3 + horizontalSpacing * 2 + btnWidth, y: verticalSpacing , width: btnWidth, height: btnHeight)
            default:
                return nil
            }
        }else if nbButtons == 3{
            StoLog.d(message: "\(self.TAG): getButtonFrame: 3 buttons")
            switch position {
            case 1:
                return CGRect(x: widthOfView / 3 + horizontalSpacing, y: verticalSpacing, width: btnWidth, height: btnHeight)
            case 2:
                return CGRect(x: widthOfView / 3 + horizontalSpacing * 2 + btnWidth, y: verticalSpacing , width: btnWidth, height: btnHeight)
            case 3:
                return CGRect(x: widthOfView / 3 + horizontalSpacing, y: verticalSpacing * 2  + btnHeight, width: btnWidth, height: btnHeight)
            default:
                return nil
            }
        }else if nbButtons == 4{
            StoLog.d(message: "\(self.TAG): getButtonFrame: 4 buttons")
            switch position {
            case 1:
                return CGRect(x: widthOfView / 3 + horizontalSpacing, y: verticalSpacing, width: btnWidth, height: btnHeight)
            case 2:
                return CGRect(x: widthOfView / 3 + horizontalSpacing * 2 + btnWidth, y: verticalSpacing , width: btnWidth, height: btnHeight)
            case 3:
                return CGRect(x: widthOfView / 3 + horizontalSpacing, y: verticalSpacing * 2  + btnHeight, width: btnWidth, height: btnHeight)
            case 4:
                return CGRect(x: widthOfView / 3 + horizontalSpacing * 2 + btnWidth, y: verticalSpacing * 2  + btnHeight, width: btnWidth, height: btnHeight)
            default:
                return nil
            }
        }else{
            StoLog.e(message: "\(self.TAG): getButtonFrame: unhandled number of buttons: \(nbButtons)")
            return nil
        }
    }
    
    
    
    /// <#Description#>
    /// Calculates the CGRect for the button, depending on it's position in the list and the super view width
    /// - Parameters:
    ///   - number: <#number description#>
    ///   - nbButtons: <#nbButtons description#>
    ///   - widthOfView: <#widthOfView description#>
    /// - Returns: <#return value description#>
    internal static func getButtonFrameV2UICollectionView(buttonPosition position: Int, numberOfButtons nbButtons: Int, heightOfView: Int, widthOfView: Int) -> CGRect?{
        let f_TAG = "getButtonFrameV2UICollectionView"
        StoLog.d(message: "\(self.TAG): \(f_TAG)")
        
        //let h0 = heightOfView / 3
        let h1 = heightOfView * 2 / 3
        
        let heightButton = h1 / 7
        
        if heightButton / widthOfView > 1 / 5{
            StoLog.d(message: "\(self.TAG): \(f_TAG): here")
        }else{
            StoLog.d(message: "\(self.TAG): \(f_TAG): here2")
        }
        return nil
    }
    
    
    /// Calculates button's height with the viewHeight
    ///
    /// - Parameter viewHeight: <#viewHeight description#>
    /// - Returns: <#return value description#>
    internal static func getButtonHeight(viewHeight: Int, ratio: Float) -> Int{
        StoLog.d(message: "\(self.TAG): getButtonHeight: viewHeight\(viewHeight)")
        
        if viewHeight > 0{
            return Int(Float(viewHeight) * ratio)
        }
        return 0
    }
    
    
    /// Calculates button's with the viewWidth
    ///
    /// - Parameters:
    ///   - viewWidth: <#viewWidth description#>
    ///   - ratio: <#ratio description#>
    /// - Returns: <#return value description#>
    internal static func getButtonWidth(viewWidth: Int, ratio: Float) -> Int{
        StoLog.d(message: "\(self.TAG): getButtonWidth: viewHeight: \(viewWidth), ratio: \(ratio)")
        
        if viewWidth > 0{
            return Int(Float(viewWidth) * ratio)
        }
        
        return 0
    }
    
    
    /// Calculates the vertical spacing between buttons of the MBFButterfly
    ///
    /// - Parameters:
    ///   - viewHeight: height of the view
    ///   - ratio: button's height / view's height
    /// - Returns:
    internal static func getButtonVerticalSpacing(viewHeight: Int,buttonHeight: Int, nbButtons: Int) -> Int{
        StoLog.d(message: "\(self.TAG): getButtonVerticalSpacing: viewHeight: \(viewHeight)")
        
        if nbButtons > 2 {
            let spacing = viewHeight - buttonHeight * 2
            if spacing != 0{
                StoLog.d(message: "\(self.TAG): getButtonVerticalSpacing: > 2, spacing : \(spacing / 3)")
                return  spacing / 3
            }else{
                return 0
            }
        }else{
            let spacing = viewHeight - buttonHeight
            if spacing > 0{
                StoLog.d(message: "\(self.TAG): getButtonVerticalSpacing: <= 2, spacing : \(spacing / 2)")
                return spacing / 2
            }else{
                return 0
            }
        }
    }
    
    /// Calculates the horizontal spacing between buttons of the MBFButterfly
    ///
    /// - Parameters:
    ///   - viewHeight: height of the view
    ///   - ratio: button's height / view's height
    /// - Returns:
    internal static func getButtonHorizontalSpacing(viewWidth: Int, buttonWidth: Int) -> Int{
        StoLog.d(message: "\(self.TAG): getButtonHorizontalSpacing: viewWidth: \(viewWidth), buttonWidth: \(buttonWidth)")
        
        if viewWidth > 0 {
            // Total size of spacings (spacing - button - spacing - button - spacing)
            let tmp = (viewWidth / 3) * 2
            StoLog.d(message: "\(self.TAG): getButtonHorizontalSpacing: tmp \(tmp)")
            if tmp > 0{
                let spacings = tmp - buttonWidth * 2
                StoLog.d(message: "\(self.TAG): getButtonHorizontalSpacing: spacings: \(spacings)")
                if spacings > 0{
                    StoLog.d(message: "\(self.TAG): getButtonHorizontalSpacing:  returning \(spacings)")
                    return spacings / 3
                }
            }
        }
        return 0
    }
    
    /// Converts the hexadecimal color code to a UIColor
    ///
    /// - Parameter hex: <#hex description#>
    /// - Returns: <#return value description#>
    internal static func hexStringToUIColor (hex:String) -> UIColor {
        if hex.isEmpty{
            return self.DF_MBF_COLOR
        }
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


    
    
    



