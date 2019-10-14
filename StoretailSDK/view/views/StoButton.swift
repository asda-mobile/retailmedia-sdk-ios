//
//  StoButton.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 17/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import UIKit

class StoButton: UIButton {
    let index : Int
    
    var productId : String?
    var stoButterfly : StoButterfly?
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init(format: StoButterfly, index : Int) {
        self.index = index
        
        super.init(frame: .zero)
        
        sharedInit()
        
        setButterfly(format, index: index)
    }
    
    override init(frame: CGRect) {
        self.index = 0
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.index = 0
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        titleLabel?.numberOfLines = 2
        titleLabel?.font = .systemFont(ofSize: 12)
        titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    func setButterfly(_ format: StoButterfly, index: Int) {
        let buttonContent = format.getButtonContentList()[index]
        
        productId = buttonContent.productIds.first!
        stoButterfly = format
        
        setTitle(buttonContent.buttonName, for: .normal)
        setTitleColor(format.getButtonTextColor(), for: .normal)
        setTitleColor(format.getButtonTextSelectedColor(), for: .selected)
        //setTitleColor(stoButterfly.getButtonTextSelectedColor(), for: .highlighted)
        
        var i = 0
        while i < format.getButtonContentList().count {
            let buttonContent = format.getButtonContentList()[i]
            if buttonContent.productIds.first == format.getProductIdSelected() {
                if index == i {
                    isSelected = true
                    //titleLabel?.textColor = stoButterfly.getButtonTextSelectedColor()
                    backgroundColor = format.getButtonSelectedColor()
                } else {
                    isSelected = false
                    //titleLabel?.textColor = stoButterfly.getButtonTextColor()
                    backgroundColor = format.getButtonColor()
                }
            }
            i += 1
        }
    }
    
    /*
    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = stoButterfly.getButtonSelectedColor()
                //titleLabel?.textColor = stoButterfly.getButtonTextSelectedColor()
            } else {
                backgroundColor = stoButterfly.getButtonColor()
                //titleLabel?.textColor = stoButterfly.getButtonTextColor()
            }
        }
    }*/
    
    override open var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = stoButterfly?.getButtonSelectedColor()
                //titleLabel?.textColor = stoButterfly.getButtonTextSelectedColor()
            } else {
                backgroundColor = stoButterfly?.getButtonColor()
                //titleLabel?.textColor = stoButterfly.getButtonTextColor()
            }
        }
    }
}
