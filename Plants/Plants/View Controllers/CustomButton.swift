//
//  CustomButton.swift
//  Plants
//
//  Created by Alexander Supe on 03.02.20.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 10 { didSet { self.layer.cornerRadius = self.cornerRadius } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        format()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        format()
    }
    
    private func format() {        
    }

}
