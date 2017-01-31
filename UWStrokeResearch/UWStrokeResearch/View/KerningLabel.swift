//
//  KerningLabel.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 1/30/17.
//  Copyright © 2017 Dilraj Devgun. All rights reserved.
//

import UIKit

class KerningLabel: UILabel {
        
    @IBInspectable var kerning:CGFloat = 0.0{
        didSet{
            if ((self.attributedText?.length) != nil)
            {
                let attribString = NSMutableAttributedString(attributedString: self.attributedText!)
                attribString.addAttributes([NSKernAttributeName:kerning], range:NSMakeRange(0, self.attributedText!.length))
                self.attributedText = attribString
            }
        }
    }

}
