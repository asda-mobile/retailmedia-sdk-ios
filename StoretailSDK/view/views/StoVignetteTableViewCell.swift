//
//  StoVignetteTableViewCell.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 24/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import UIKit

public class StoVignetteTableViewCell : UITableViewCell {
    
    weak var formatDelegate : StoFormatViewProtocol?
    
    var backgroundImage : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.contentMode = ContentMode.scaleAspectFill
        return imageView
    }()
    
    var backgroundWidthConstraint : NSLayoutConstraint?
    var backgroundHeightConstraint : NSLayoutConstraint?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    
    public func setDatas(type: StoFormatType, image: UIImage, backgroundColor: UIColor, parentWidth: CGFloat) {
        backgroundImage.image = image
        contentView.backgroundColor = backgroundColor
        
        if type == .stoBanner {
            if image.size.width < parentWidth {
                backgroundWidthConstraint?.constant = image.size.width
                backgroundHeightConstraint!.constant = image.size.height
                
                NSLayoutConstraint.activate([
                    backgroundWidthConstraint!,
                    backgroundHeightConstraint!,
                    backgroundImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
                    backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])
            } else {
                backgroundHeightConstraint!.constant = parentWidth * image.getRatio()
                NSLayoutConstraint.activate([
                    backgroundHeightConstraint!,
                    backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
                    backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])
            }
        } else if type == .stoVignette {
            backgroundImage.image = image
            backgroundHeightConstraint!.constant = parentWidth * image.getRatio()
            contentView.backgroundColor = backgroundColor
            
            NSLayoutConstraint.activate([
                backgroundHeightConstraint!,
                backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
                backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
