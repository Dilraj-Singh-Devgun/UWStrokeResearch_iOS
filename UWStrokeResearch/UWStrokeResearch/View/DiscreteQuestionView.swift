//
//  DiscreteQuestionView.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 12/22/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//
//  A discrete question view displays a question with three buttons indicating yes, no, and maybe
//

import UIKit

// a protocol for which a delegate of the DiscreteQuestionView can conform to
protocol DiscreteQuestionViewDelegate {
    func discreteQuestionViewDidPressButton(sender:UIButton, pressed:Int)
    func discreteQestionViewTappedInactive(sender:DiscreteQuestionView)
}

class DiscreteQuestionView: UIView {

    @IBOutlet weak var QuestionLabel: UILabel!
    var delegate:DiscreteQuestionViewDelegate?
    var coverView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    init(frame:CGRect, question:String) {
        super.init(frame: frame)
        setUp()
        //add the question to the question label and adjust the font size to fit within the width of the view
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
    
    // a setup method which gets the view from the xib file we created. This will allow us to put that xib in our view
    func setUp() {
        //get the bundle of our project
        let bundle = Bundle(for: type(of: self))
        //get the nib class from our project
        let nib = UINib(nibName: "DiscreteQuestionView", bundle: bundle)
        //get the view we designed in the nib file and then add it as a subview to the uiview with the approproate constraints
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
    
    // When the button is pressed make the others disappear and notify the delegate that the button was pressed
    @IBAction func pressedButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            let v1 = viewWithTag(2)
            let v2 = viewWithTag(3)
            v1?.alpha = 0
            v2?.alpha = 0
            break
        case 2:
            let v1 = viewWithTag(1)
            let v2 = viewWithTag(3)
            v1?.alpha = 0
            v2?.alpha = 0
            break
        case 3:
            let v1 = viewWithTag(1)
            let v2 = viewWithTag(2)
            v1?.alpha = 0
            v2?.alpha = 0
            break
        default:
            break
        }
        if let _ = self.delegate {
            delegate?.discreteQuestionViewDidPressButton(sender: sender, pressed: sender.tag)
        }
        
    }
    
    //Manually set the question to be displayed
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
            delegate?.discreteQestionViewTappedInactive(sender: self)
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
