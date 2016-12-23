//
//  DiscreteQuestionView.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 12/22/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//

import UIKit

protocol DiscreteQuestionViewDelegate {
    func discreteQuestionViewDidPressButton(sender:UIButton, pressed:Int)
}

class DiscreteQuestionView: UIView {

    @IBOutlet weak var QuestionLabel: UILabel!
    var delegate:DiscreteQuestionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    init(frame:CGRect, question:String) {
        super.init(frame: frame)
        setUp()
        self.QuestionLabel.text = question
        self.QuestionLabel.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func prepareForInterfaceBuilder() {
        setUp()
    }
    
    func setUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DiscreteQuestionView", bundle: bundle)
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
    
    @IBAction func pressedButton(_ sender: UIButton) {
        if let _ = self.delegate {
            delegate?.discreteQuestionViewDidPressButton(sender: sender, pressed: sender.tag)
        }
    }
    
    func setQuestion(question:String) {
        self.QuestionLabel.text = question
    }
}
