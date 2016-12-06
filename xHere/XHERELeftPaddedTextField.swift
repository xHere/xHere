//
//  XHERELeftPaddedTextField.swift
//  xHere
//
//  Created by Ruchit Mehta on 12/5/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHERELeftPaddedTextField: UITextField {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width-50, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }


}
