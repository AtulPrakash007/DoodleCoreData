//
//  RoundButton.swift
//  DoodleCoreData
//
//  Created by Atul on 22/12/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
        customize()
    }
    
    @IBInspectable var rounded: Bool = true {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 4 : 0
        layer.borderColor = UIColor.red.cgColor as CGColor
        layer.borderWidth = 2.0
        
        clipsToBounds = true
    }
    
    func customize() {
        titleLabel?.textAlignment = .center
    }
}
