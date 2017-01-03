//
//  RangeQuestionView.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 12/22/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//
//  A range question view which displays an input field and question for questions that 
//  require user's to input a value within a range.
//

import UIKit

// delegate protocol to send a notification that a range has been entered.
protocol RangeQuestionViewDelegate {
    func rangeQuestionViewDidPressButton(value:String)
}

class RangeQuestionView: UIView {

    @IBOutlet weak var QuestionLabel: UILabel! // the question label
    @IBOutlet weak var inputTextField: UITextField! // the input field
    var delegate:RangeQuestionViewDelegate? // an optional delegate for the range question view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    init(frame:CGRect, question:String) {
        super.init(frame: frame)
        setUp()
        self.QuestionLabel.text = question // set the question label to display the question
        self.QuestionLabel.adjustsFontSizeToFitWidth = true // adjust the font to fit the width of the scren
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func prepareForInterfaceBuilder() {
        setUp()
    }
    
    // a setup method which gets the view from the xib file we created. This will allow us to put that xib in our view
    func setUp() {
        //get the bundle which our project is located in
        let bundle = Bundle(for: type(of: self))
        //get the nib file using our bundle
        let nib = UINib(nibName: "RangeQuestionView", bundle: bundle)
        //grab the view from the nib file
        let viewFromNib = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        //ad the nib's view as a subview to the UIView
        addSubview(viewFromNib)
        //add the appropriate constraints
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
    
    //When the dont button is pressed notify the delegate
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.inputTextField.resignFirstResponder()
        if let _ = self.delegate {
            self.delegate!.rangeQuestionViewDidPressButton(value: self.inputTextField.text!)
        }
    }
    
    //if we tap outside the textfield then resign the first responder
    @IBAction func tappedOutside(_ sender: Any) {
        self.inputTextField.resignFirstResponder()
    }
    
    //set the question of the uilabel 
    func setQuestion(question:String) {
        self.QuestionLabel.text = question
    }
}
