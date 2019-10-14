//
//  StoVignetteCollectionViewCell.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 24/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import UIKit
import Nuke

class StoVignetteCollectionViewCell: UICollectionViewCell {
    
    var backgroundImage : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = ContentMode.scaleAspectFill
        return imageView
    }()
    
    var backgroundWidthConstraint : NSLayoutConstraint?
    var backgroundHeightConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundImage)
        clipsToBounds = true
        
        backgroundWidthConstraint = backgroundImage.widthAnchor.constraint(equalToConstant: 0)
        backgroundHeightConstraint = backgroundImage.heightAnchor.constraint(equalToConstant: 0)
    }
    
    public override func prepareForReuse() {
        backgroundImage.image = nil
        
        backgroundImage.removeConstraints(backgroundImage.constraints)
        removeConstraints(constraints)
    }
    
    public func setBannerDatas(image: UIImage, backgroundColor: UIColor, parentWidth: CGFloat) {
        backgroundImage.image = image
        self.backgroundColor = backgroundColor
        
        if image.size.width < parentWidth {
            backgroundWidthConstraint?.constant = image.size.width
            backgroundHeightConstraint!.constant = image.size.height
            
            NSLayoutConstraint.activate([
                backgroundWidthConstraint!,
                backgroundHeightConstraint!,
                backgroundImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
                //backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])
        } else {
            backgroundWidthConstraint?.constant = parentWidth
            backgroundHeightConstraint!.constant = parentWidth * image.getRatio()
            NSLayoutConstraint.activate([
                backgroundWidthConstraint!,
                backgroundHeightConstraint!,
                backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
                backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])
        }
    }
    
    public func setVignetteDatas(image: UIImage, backgroundColor: UIColor, isGrid: Bool, size: CGSize) {
        backgroundImage.image = image
        self.backgroundColor = backgroundColor
        
        if isGrid {
            image.resizeImage(in: backgroundImage, imageViewSize: size, widthConstraint: backgroundWidthConstraint!, heightConstraint: backgroundHeightConstraint!)
        } else {
             backgroundWidthConstraint?.constant = size.width
             backgroundHeightConstraint?.constant = size.width * image.getRatio()
        }
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundWidthConstraint!,
            backgroundHeightConstraint!
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
