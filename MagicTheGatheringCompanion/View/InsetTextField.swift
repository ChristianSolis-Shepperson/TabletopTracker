//
//  InsetTextField.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 6/3/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import UIKit
@IBDesignable

class InsetTextField: UITextField {
    
    override func awakeFromNib() {
        setupView()
        super.awakeFromNib()
    }
    
    func setupView(){
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
        self.attributedPlaceholder = placeholder
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
}
