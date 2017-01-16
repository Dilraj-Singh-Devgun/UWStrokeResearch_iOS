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
    func rangeQestionViewTappedInactive(sender:RangeQuestionView)
    func rangeTextViewDidBeginEditing(sender:Any)
    func rangeTextViewDidEndEditing(sender:Any)
}

class RangeQuestionView: UIView {

    @IBOutlet weak var QuestionLabel: UILabel! // the question label
    @IBOutlet weak var inputTextField: UITextField! // the input field
    var delegate:RangeQuestionViewDelegate? // an optional delegate for the range question view
    var coverView:UIView?
    
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
        if self.inputTextField.text == "" {
            UIView.animate(withDuration: 0.3, animations: {() in self.inputTextField.backgroundColor = UIColor(red:255/255, green:94/255, blue:100/255, alpha:1) }, completion: {(success) in
                UIView.animate(withDuration: 0.3, animations: {() in self.inputTextField.backgroundColor = UIColor.white }, completion: nil) })
            return
        }
        if let _ = self.delegate {
            self.delegate!.rangeQuestionViewDidPressButton(value: self.inputTextField.text!)
            self.delegate!.rangeTextViewDidEndEditing(sender: sender)
        }
    }
    
    //if we tap outside the textfield then resign the first responder
    @IBAction func tappedOutside(_ sender: Any) {
        self.inputTextField.resignFirstResponder()
        if let _ = self.delegate {
            self.delegate?.rangeTextViewDidEndEditing(sender: sender)
        }
        
    }
    
    //set the question of the uilabel 
    func setQuestion(question:String) {
        self.QuestionLabel.text = question
    }
    
    //Makes the view inactive by placing a faded view ontop to act as a cover and then blocks any interaction with the controls in the view
    func setInactive() {
        if let _ = self.coverView {
            return
        }
        //make the cover view with a white background and a transparancy to act as a faded vie
        self.coverView = UIView(frame: self.bounds)
        self.coverView!.backgroundColor = UIColor.white
        self.coverView!.alpha = 0.8
        self.addSubview(coverView!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(DiscreteQuestionView.didTapOldView))
        coverView!.addGestureRecognizer(tap)
    }
    
    func didTapOldView(){
        if let _ = self.delegate {
            self.delegate?.rangeQestionViewTappedInactive(sender: self)
        }
    }
    @IBAction func textViewDidBeginEditing(_ sender: Any) {
        if let _ = self.delegate {
            self.delegate?.rangeTextViewDidBeginEditing(sender: sender)
        }
    }
    
    @IBAction func textViewDidEndEditing(_ sender: Any) {
        if let _ = self.delegate {
            self.delegate?.rangeTextViewDidEndEditing(sender: sender)
        }
    }
    
    //make the view active and interactive again by removing the cover view and making all the buttons visable again
    func setActive(){
        if let cv = self.coverView {
            cv.removeFromSuperview()
            self.coverView = nil
        }
        
        let v1 = viewWithTag(1)
        let v2 = viewWithTag(2)
        let v3 = viewWithTag(3)
        v1?.alpha = 1
        v2?.alpha = 1
        v3?.alpha = 1
    }
}
