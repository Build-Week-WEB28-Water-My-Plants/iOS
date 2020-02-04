//
//  CustomField.swift
//  Plants
//
//  Created by Alexander Supe on 03.02.20.
//

import UIKit

@IBDesignable
class CustomField: UITextField {

    @IBInspectable
    var cornerRadius: CGFloat = 10 { didSet { self.layer.cornerRadius = self.cornerRadius } }
    
    @IBInspectable var vInset: CGFloat = 0
    override func textRect(forBounds bounds: CGRect) -> CGRect {return bounds.insetBy(dx: vInset, dy: 0)}
    override func editingRect(forBounds bounds: CGRect) -> CGRect { return bounds.insetBy(dx: vInset, dy: 0)}
    
}
