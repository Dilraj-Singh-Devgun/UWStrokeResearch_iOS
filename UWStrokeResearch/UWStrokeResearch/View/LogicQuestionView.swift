//
//  LogicQuestionView.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 1/16/17.
//  Copyright © 2017 Dilraj Devgun. All rights reserved.
//

import UIKit

protocol LogicQuestionViewDelegate {

}

class LogicQuestionView: UIView, RangeQuestionViewDelegate, DiscreteQuestionViewDelegate{

    @IBOutlet weak var topQuestionView: UIView!
    @IBOutlet weak var bottomQuestionView: UIView!
    
    var questionNode1:Node?
    var questionNode2:Node?
    
    var delegate:LogicQuestionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    init(frame:CGRect, question:String) {
        super.init(frame: frame)
        setUp()
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
        let nib = UINib(nibName: "LogicQuestionView", bundle: bundle)
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
    
    func setQuestions(node1:Node, node2:Node) {
        self.questionNode1 = node1
        self.questionNode2 = node2
        
        let nodes = [node1, node2]
        let views = [topQuestionView, bottomQuestionView]
        
        for i in 0 ..< 2 {
            let node = nodes[i]
            let subview = views[i]
            
            switch node.type {
            case "BUTTON":
                let qv = DiscreteQuestionView(frame: (subview?.bounds)!, question: node.question)
                qv.delegate = self
                subview?.addSubview(qv)
                break
            case "NUMBER":
                let qv = RangeQuestionView(frame: (subview?.bounds)!, question: node.question)
                qv.delegate = self
                subview?.addSubview(qv)
                break
            default:
                break
            }
        }
    }
    
    func discreteQestionViewTappedInactive(sender: DiscreteQuestionView) {
        
    }
    
    func discreteQuestionViewDidPressButton(sender: UIButton, pressed: Int) {
        
    }
    
    func rangeQuestionViewDidPressButton(value: String) {
        
    }
    
    func rangeTextViewDidEndEditing(sender: Any) {
        
    }
    
    func rangeTextViewDidBeginEditing(sender: Any) {
        
    }
    
    func rangeQestionViewTappedInactive(sender: RangeQuestionView) {
        
    }

}
