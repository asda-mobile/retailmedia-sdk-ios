//
//  UIImage+Extension.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 24/07/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizeImage(in imageView: UIImageView, imageViewSize: CGSize, widthConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint) {
        imageView.image = self
        let imageWidth = size.width
        let imageHeight = size.height
        
        NSLog("resizeImage image:(\(imageWidth), \(imageHeight))")
        NSLog("resizeImage background:\(imageViewSize)")
        
        var ratio : CGFloat = 1.0
        
        if imageWidth > imageViewSize.width {
            if imageViewSize.width > imageViewSize.height {
                ratio = (imageViewSize.width / imageWidth)
            } else {
                ratio = (imageViewSize.height / imageHeight)
            }
        }
        let newWidth = imageWidth * ratio
        let newHeight = imageHeight * ratio
        
        NSLog("resizeImage W > H newSize:(\(newWidth), \(newHeight))")
        widthConstraint.constant = newWidth
        heightConstraint.constant = newHeight
    }
    
    func getRatio() -> CGFloat {
        return CGFloat(self.size.height / self.size.width)
    }
}
