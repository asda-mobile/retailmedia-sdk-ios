//
//  StoButterflyTabletTableViewCell.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 19/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import UIKit
import Nuke

class StoButterflyTabletTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundColorView  : UIView!
    @IBOutlet weak var rightView            : UIView!
    @IBOutlet weak var backgroundImage      : UIImageView!
    @IBOutlet weak var buttonsView          : UIView!
    
    @IBOutlet weak var backgroundWidth      : NSLayoutConstraint!
    @IBOutlet weak var backgroundHeight     : NSLayoutConstraint!
    
    private var buttons : [StoButton] = []
    
    weak var butterflyDelegate : StoButterflyViewProtocol?
    weak var formatDelegate : StoFormatViewProtocol?
    
    private var format                  : StoButterfly? {
        willSet {
            buttonsView.subviews.forEach({ $0.removeFromSuperview() })
            backgroundImage.image = nil
        }
        didSet {
            // Set the background color
            if let backgroundColor = format?.getBackgroundColor(), backgroundColor != UIColor.clear {
                backgroundColorView.backgroundColor = backgroundColor
            }
            // Set the background image
            if format?.hasMultiBackgrounds() ?? false, let backgroundImageURL = format?.getMultiBackground(atIndex: 0) {
                ImagePipeline.shared.loadImage(with: backgroundImageURL, progress: nil) { response, err in
                    if err == nil, let image = response?.image {
                        image.resizeImage(in: self.backgroundImage, imageViewSize: self.rightView.frame.size, widthConstraint: self.backgroundWidth, heightConstraint: self.backgroundHeight)
                    }
                }
            } else if let backgroundImageURL = format?.getBackgroundImageURL(isTablet: true) {
                NSLog("bgWidth: \(self.backgroundImage.frame.size)")
                ImagePipeline.shared.loadImage(with: backgroundImageURL, progress: nil) { response, err in
                    if err == nil, let image = response?.image {
                        image.resizeImage(in: self.backgroundImage, imageViewSize: self.rightView.frame.size, widthConstraint: self.backgroundWidth, heightConstraint: self.backgroundHeight)
                    }
                }
            }
            
            // borderColor
            if let borderColor = format?.getBorderColor() {
                contentView.backgroundColor = borderColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func stoButtonClicked(_ sender: StoButton) {
        buttons.forEach { $0.isSelected = false}
        
        sender.isSelected = true
        
        if sender.stoButterfly?.hasMultiBackgrounds() ?? false {
            if let backgroundImageURL = sender.stoButterfly?.getMultiBackground(atIndex: sender.index) {
                ImagePipeline.shared.loadImage(with: backgroundImageURL, progress: nil) { response, err in
                    if err == nil, let image = response?.image {
                        image.resizeImage(in: self.backgroundImage, imageViewSize: self.rightView.frame.size, widthConstraint: self.backgroundWidth, heightConstraint: self.backgroundHeight)
                    }
                }
            }
        }
        
        format?.setProductIdSelected(productId: sender.productId!)
        
        butterflyDelegate?.buttonCliked(cell: self, productId: sender.productId!)
    }
    
    @objc func optionButtonClicked() {
        formatDelegate?.buttonOptionClicked(format: format!)
    }
    
    private func addMaxDisplayableButtons(_ productViewHeight: CGFloat) {
        var minViewHeight : CGFloat = 140.0 + 6.0
        
        if let format = self.format {
            
            self.buttonsView.subviews.forEach({
                $0.removeFromSuperview()
            })
            
            if addOptionView() {
                minViewHeight += 35.0
            }
            if productViewHeight < minViewHeight {
                contentView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                layoutMargins = .zero
                StoLog.e(message: "Cannot display Butterfly, productView's height too small")
                return
            } else {
                // Add a view in order to center stackView inside
                let stackViewContainer = UIView(frame: .zero)
                stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
                
                var stackViewContainerBottomLayoutConstraint = stackViewContainer.bottomAnchor.constraint(equalTo: self.buttonsView.bottomAnchor, constant: 0)
                if let lastSubview = self.buttonsView.subviews.last {
                    stackViewContainerBottomLayoutConstraint = stackViewContainer.bottomAnchor.constraint(equalTo: lastSubview.topAnchor, constant: -5)
                }
                
                self.buttonsView.addSubview(stackViewContainer)
                
                NSLayoutConstraint.activate([
                    stackViewContainerBottomLayoutConstraint,
                    stackViewContainer.topAnchor.constraint(equalTo: self.buttonsView.topAnchor),
                    stackViewContainer.leftAnchor.constraint(equalTo: self.buttonsView.leftAnchor),
                    stackViewContainer.rightAnchor.constraint(equalTo: self.buttonsView.rightAnchor)
                ])
                
                // Add stack view
                let stackView = UIStackView()
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.axis = .vertical
                stackView.spacing = 5.0
                
                stackViewContainer.addSubview(stackView)
                
                NSLayoutConstraint.activate([
                    stackView.widthAnchor.constraint(equalTo: stackViewContainer.widthAnchor),
                    stackView.centerXAnchor.constraint(equalTo: stackViewContainer.centerXAnchor),
                    stackView.centerYAnchor.constraint(equalTo: stackViewContainer.centerYAnchor)
                ])
                
                // Add button to stackview
                var i = 0
                while (i < format.getButtonContentList().count && minViewHeight + 35.0 <= productViewHeight) {
                    let button = StoButton(format: format, index: i)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    buttons.append(button)
                    stackView.addArrangedSubview(button)
                    
                    NSLayoutConstraint.activate([
                        button.heightAnchor.constraint(equalToConstant: 30),
                        button.widthAnchor.constraint(equalTo: stackView.widthAnchor)
                    ])
                    
                    button.addTarget(self, action: #selector(stoButtonClicked(_:)), for: .touchUpInside)
                    
                    minViewHeight += 35
                    i += 1
                }
                contentView.heightAnchor.constraint(equalToConstant: productViewHeight).isActive = true
            }
        }
    }
    
    private func addOptionView() -> Bool {
        if let format = self.format {
            let optionType = format.getOptionType()
            if optionType != .none {
                if optionType == .legal {
                    // Legal text option
                    let optionLabel = UILabel()
                    optionLabel.translatesAutoresizingMaskIntoConstraints = false
                    optionLabel.font = .systemFont(ofSize: 12)
                    optionLabel.numberOfLines = 0
                    optionLabel.textAlignment = .center
                    optionLabel.adjustsFontSizeToFitWidth = true
                    optionLabel.textColor = format.getOptionTextColor()
                    optionLabel.text = format.getOptionText()
                    self.buttonsView.addSubview(optionLabel)
                    NSLayoutConstraint.activate([
                        optionLabel.heightAnchor.constraint(equalToConstant: 30),
                        optionLabel.bottomAnchor.constraint(equalTo: self.buttonsView.bottomAnchor),
                        optionLabel.leftAnchor.constraint(equalTo: self.buttonsView.leftAnchor),
                        optionLabel.rightAnchor.constraint(equalTo: self.buttonsView.rightAnchor)
                        ])
                } else {
                    // Button option
                    let optionButton = UIButton(type: .custom)
                    optionButton.translatesAutoresizingMaskIntoConstraints = false
                    optionButton.setTitleColor(format.getOptionTextColor(), for: .normal)
                    optionButton.backgroundColor = format.getOptionButtonColor()
                    if let bgImageURL = format.getOptionButtonImage(), let bgImageView = optionButton.imageView {
                        Nuke.loadImage(with: bgImageURL, into: bgImageView)
                    }
                    optionButton.setTitle(format.getOptionText(), for: .normal)
                    self.buttonsView.addSubview(optionButton)
                    NSLayoutConstraint.activate([
                        optionButton.heightAnchor.constraint(equalToConstant: 30),
                        optionButton.bottomAnchor.constraint(equalTo: self.buttonsView.bottomAnchor),
                        optionButton.leftAnchor.constraint(equalTo: self.buttonsView.leftAnchor),
                        optionButton.rightAnchor.constraint(equalTo: self.buttonsView.rightAnchor)
                    ])
                    let singleTap = UITapGestureRecognizer(target: self, action: #selector(optionButtonClicked))
                    optionButton.addGestureRecognizer(singleTap)
                }
                return true
            }
        }
        return false
    }
}

extension StoButterflyTabletTableViewCell : StoButterflyCellProtocol {
    func setButterflyFormat(stoButterfly: StoButterfly) {
        self.format = stoButterfly
    }
    func getButterflyFormat() -> StoButterfly? {
        return self.format
    }
    func addProductView(view: UIView) {
        NSLog("StoButterflyPhone addProductView")
        while rightView.subviews.count > 0 {
            rightView.subviews.last?.removeFromSuperview()
        }
        
        let viewHeight = view.frame.size.height
        
        rightView.addSubview(view)
        view.fixInView(rightView)
        
        addMaxDisplayableButtons(viewHeight)
    }
}
