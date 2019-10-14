//
//  StoButterflyPhoneCollectionViewCell.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 22/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import Foundation
import Nuke

class StoButterflyPhoneCollectionViewCell: UICollectionViewCell {
    private let TAG = "StoButterflyPhoneCollectionViewCell"
    
    @IBOutlet weak var containerView    : UIView!
    @IBOutlet weak var topView          : UIView!
    @IBOutlet weak var bottomView       : UIView!
    @IBOutlet weak var backgroundImage  : UIImageView!
    @IBOutlet weak var logoImage        : UIImageView!
    @IBOutlet weak var rightView        : UIView!
    @IBOutlet weak var buttonsView      : UIView!
    
    weak var butterflyDelegate : StoButterflyViewProtocol?
    weak var formatDelegate : StoFormatViewProtocol?
    
    private var format: StoButterfly? {
        willSet {
            buttonsView.subviews.forEach({ $0.removeFromSuperview() })
            buttons.removeAll()
            backgroundImage.image = nil
            logoImage.image = nil
            
            var logoHasLeftAndRightConstraints = false
            topView.constraints.forEach({
                if $0.identifier == "logo-left" || $0.identifier == "logo-right" {
                    logoHasLeftAndRightConstraints = true
                }
            })
            if !logoHasLeftAndRightConstraints {
                let leftConstraint = NSLayoutConstraint(item: logoImage, attribute: .left, relatedBy: .equal, toItem: topView, attribute: .left, multiplier: 1.0, constant: 0)
                leftConstraint.identifier = "logo-left"
                
                let rightConstraint = NSLayoutConstraint(item: logoImage, attribute: .right, relatedBy: .equal, toItem: rightView, attribute: .left, multiplier: 1.0, constant: 0)
                rightConstraint.identifier = "logo-right"
                
                NSLayoutConstraint.activate([
                    leftConstraint,
                    rightConstraint
                ])
            }
        }
        didSet {
            // Set the background color
            if let backgroundColor = format?.getBackgroundColor(), backgroundColor != UIColor.clear {
                backgroundImage.backgroundColor = backgroundColor
            }
            // Set the background image
            if let backgroundImageURL = format?.getBackgroundImageURL(isTablet: false) {
                Nuke.loadImage(with: backgroundImageURL, into: backgroundImage)
            }
            // Set the logo image
            if let logoImageURL = format?.getLogoImageURL() {
                Nuke.loadImage(with: logoImageURL, into: logoImage)
            }
            // borderColor
            if let borderColor = format?.getBorderColor() {
                contentView.backgroundColor = borderColor
            }
            
            setButtons()
            setTargetActions()
        }
    }
    
    private var buttons : [StoButton] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override var isSelected: Bool {
        didSet {
            
        }
    }
    
    private func setButtons() {
        if let format = self.format {
            let buttonsCount = format.getButtonContentList().count
            
            buttonsView.subviews.forEach {
                $0.removeFromSuperview()
            }
            
            var i = 0
            if buttonsCount > 1 {
                while i < buttonsCount && i < 4 {
                    let button = StoButton(format: format, index: i)
                    
                    button.translatesAutoresizingMaskIntoConstraints = false
                    buttonsView.addSubview(button)
                    buttons.append(button)
                    
                    NSLayoutConstraint.activate([
                        button.widthAnchor.constraint(equalTo: backgroundImage.widthAnchor, multiplier: (340/1242)),
                        button.heightAnchor.constraint(equalTo: backgroundImage.heightAnchor, multiplier: (1.0/3.0))
                        ])
                    i += 1
                }
            }
            
            if buttonsCount >= 4 {
                NSLayoutConstraint.activate([
                    buttons[0].topAnchor.constraint(equalTo: buttonsView.topAnchor),
                    buttons[0].leftAnchor.constraint(equalTo: buttonsView.leftAnchor),
                    
                    buttons[1].topAnchor.constraint(equalTo: buttonsView.topAnchor),
                    buttons[1].rightAnchor.constraint(equalTo: buttonsView.rightAnchor),
                    
                    buttons[2].bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
                    buttons[2].leftAnchor.constraint(equalTo: buttonsView.leftAnchor),
                    
                    buttons[3].bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
                    buttons[3].rightAnchor.constraint(equalTo: buttonsView.rightAnchor)
                    ])
            } else if buttonsCount == 3 {
                NSLayoutConstraint.activate([
                    buttons[0].topAnchor.constraint(equalTo: buttonsView.topAnchor),
                    buttons[0].leftAnchor.constraint(equalTo: buttonsView.leftAnchor),
                    
                    buttons[1].topAnchor.constraint(equalTo: buttonsView.topAnchor),
                    buttons[1].rightAnchor.constraint(equalTo: buttonsView.rightAnchor),
                    
                    buttons[2].bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
                    buttons[2].leftAnchor.constraint(equalTo: buttonsView.leftAnchor)
                    ])
            } else if buttonsCount == 2 {
                NSLayoutConstraint.activate([
                    buttons[0].centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
                    buttons[0].leftAnchor.constraint(equalTo: buttonsView.leftAnchor),
                    
                    buttons[1].centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
                    buttons[1].rightAnchor.constraint(equalTo: buttonsView.rightAnchor)
                    ])
            } else {
                topView.constraints.forEach({
                    if $0.identifier == "logo-left" || $0.identifier == "logo-right" {
                        topView.removeConstraint($0)
                    }
                })
                logoImage.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor).isActive = true
            }
        }
    }
    
    private func setTargetActions() {
        for button in buttons {
            button.addTarget(self, action: #selector(stoButtonClicked(_:)), for: .touchUpInside)
        }
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(optionButtonClicked))
        logoImage.addGestureRecognizer(singleTap)
    }
    
    @objc func stoButtonClicked(_ sender: StoButton) {
        
        buttons.forEach({ $0.isSelected = false})
        
        sender.isSelected = true
        format?.setProductIdSelected(productId: sender.productId!)
        
        butterflyDelegate?.buttonCliked(cell: self, productId: sender.productId!)
    }
    
    @objc func optionButtonClicked() {
        formatDelegate?.buttonOptionClicked(format: format!)
    }
}

extension StoButterflyPhoneCollectionViewCell : StoButterflyCellProtocol {
    func setButterflyFormat(stoButterfly: StoButterfly) {
        self.format = stoButterfly
    }
    
    func getButterflyFormat() -> StoButterfly? {
        return self.format
    }
    
    func addProductView(view: UIView) {
        NSLog("\(TAG) addProductView")
        while bottomView.subviews.count > 0 {
            bottomView.subviews.last?.removeFromSuperview()
        }
        
        bottomView.addSubview(view)
        
        bottomView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .width {
                bottomView.removeConstraint(constraint)
            }
        }
    
        view.fixInView(bottomView)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}
