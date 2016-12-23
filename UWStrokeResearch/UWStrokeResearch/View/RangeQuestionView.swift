//
//  RangeQuestionView.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 12/22/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//

import UIKit

protocol RangeQuestionViewDelegate {
    func rangeQuestionViewDidPressButton(value:String)
}

class RangeQuestionView: UIView {

    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    var delegate:RangeQuestionViewDelegate?
    
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
        let nib = UINib(nibName: "RangeQuestionView", bundle: bundle)
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
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.inputTextField.resignFirstResponder()
        if let _ = self.delegate {
            self.delegate!.rangeQuestionViewDidPressButton(value: self.inputTextField.text!)
        }
    }
    
    @IBAction func tappedOutside(_ sender: Any) {
        self.inputTextField.resignFirstResponder()
    }
    
    func setQuestion(question:String) {
        self.QuestionLabel.text = question
    }
}
