//
//  TestXib.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 12/21/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//

import UIKit

@IBDesignable class TestXib: UIView {

    @IBInspectable var innerViewColor:UIColor = UIColor.black
    @IBOutlet weak var innerView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        self.innerView.backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
        self.innerView.backgroundColor = UIColor.black
    }
    
    override func prepareForInterfaceBuilder() {
        setUp()
        self.innerView.backgroundColor = UIColor.black
    }
    
    func setUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TestXib", bundle: bundle)
        let viewFromNib = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(viewFromNib)
        viewFromNib.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[v]|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: ["v":viewFromNib]
            )
        )
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[v]|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil, views: ["v":viewFromNib]
            )
        )
    }
    
    
}
