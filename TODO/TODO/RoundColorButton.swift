//
//  RoundColorButton.swift
//  TODO
//
//  Created by Satsishur on 16.12.2020.
//

import UIKit

class RoundColorButton: UIButton {
    var cornerRadius : CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
//    var borderWidth : CGFloat = 0 {
//        didSet{
//            self.layer.borderWidth = borderWidth
//        }
//    }
//
//    var borderColor : UIColor = UIColor.clear {
//        didSet{
//            self.layer.borderColor = borderColor.cgColor
//        }
//    }
    
    var isSet: Bool = false {
        didSet {
            if isSet == true {
                self.layer.borderColor = UIColor.systemGray2.cgColor
                self.layer.borderWidth = 2
            } else {
                self.layer.borderColor = UIColor.clear.cgColor
                self.layer.borderWidth = 0
            }
        }
    }
}