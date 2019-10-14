//
//  UIView+Anchor.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 12/07/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    func fixInView(_ container: UIView!) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false
        //self.frame = container.frame
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
