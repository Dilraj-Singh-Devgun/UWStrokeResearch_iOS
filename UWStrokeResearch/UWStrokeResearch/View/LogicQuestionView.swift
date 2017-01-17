//
//  LogicQuestionView.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 1/16/17.
//  Copyright © 2017 Dilraj Devgun. All rights reserved.
//

import UIKit

protocol LogicQuestionViewDelegate {
    func logicQuestionViewTappedInactive()
    func logicQuestionViewBeganEditing()
    func logicQuestoinViewStoppedEditing()
    func logicQuestionViewRangeAnswered(node:Node, value:String)
    func logicQuestionViewDiscreteAnswered(node:Node, sender:UIButton, pressed:Int)
}

class LogicQuestionView: UIView, RangeQuestionViewDelegate, DiscreteQuestionViewDelegate{

    @IBOutlet weak var topQuestionView: UIView!
    @IBOutlet weak var bottomQuestionView: UIView!
    var coverView:UIView?
    
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
    
    func setQuestions(node1:Node, node2:Node, frame:CGRect) {
        self.questionNode1 = node1
        self.questionNode2 = node2
        
        let nodes = [node1, node2]
        let views = [topQuestionView, bottomQuestionView]
        
        for i in 0 ..< 2 {
            let node = nodes[i]
            let subview = views[i]
            
            switch node.type {
            case "BUTTON":
                let qv = DiscreteQuestionView(frame: frame, question: node.question)
                qv.delegate = self
                qv.tag = i + 1
                subview?.addSubview(qv)
                break
            case "NUMBER":
                let qv = RangeQuestionView(frame: frame, question: node.question)
                qv.delegate = self
                qv.tag = i + 1
                subview?.addSubview(qv)
                break
            default:
                break
            }
        }
    }
    
    func discreteQestionViewTappedInactive(sender: DiscreteQuestionView) {
        if let _ = self.delegate {
            self.delegate?.logicQuestionViewTappedInactive()
        }
    }
    
    func discreteQuestionViewDidPressButton(sender: UIButton, pressed: Int, view:UIView) {
        let num = view.tag - 1
        self.setInactive()
        if let _ = self.delegate {
            self.delegate?.logicQuestionViewDiscreteAnswered(node: num == 0 ? self.questionNode1! : self.questionNode2!, sender: sender, pressed: pressed)
        }
    }
    
    func rangeQuestionViewDidPressButton(value: String, view:UIView) {
        let num = view.tag - 1
        self.setInactive()
        if let _ = self.delegate {
            self.delegate?.logicQuestionViewRangeAnswered(node: num == 0 ? self.questionNode1! : self.questionNode2!, value: value)
        }
        
    }
    
    func rangeTextViewDidEndEditing(sender: Any) {
        if let _ = self.delegate {
            self.delegate?.logicQuestoinViewStoppedEditing()
        }
    }
    
    func rangeTextViewDidBeginEditing(sender: Any) {
        if let _ = self.delegate {
            self.delegate?.logicQuestionViewBeganEditing()
        }
    }
    
    func rangeQestionViewTappedInactive(sender: RangeQuestionView) {
        if let _ = self.delegate {
            self.delegate?.logicQuestionViewTappedInactive()
        }
    }
    
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
