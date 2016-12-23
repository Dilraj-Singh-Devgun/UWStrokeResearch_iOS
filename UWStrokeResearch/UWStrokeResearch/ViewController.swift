//
//  ViewController.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 11/27/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DiscreteQuestionViewDelegate, RangeQuestionViewDelegate {
    
    var handler:QuestionHandler!
    var currentQuestion:(node: Node?, message:String)!
    @IBOutlet weak var questionView: UIView!
    var currentView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.handler = QuestionHandler()
        
        self.handler.giveInput(input: "start", forNode: nil)
        print(handler.getCurrentQuestion().question + " " + handler.getCurrentQuestion().node!.QID)
        let node = self.handler.getCurrentQuestion().node
        self.currentQuestion = (node, handler.getCurrentQuestion().question)
//
//        handler.giveInput(input: "yes", forNode: nil)
//        print(handler.getCurrentQuestion().question + " " + handler.getCurrentQuestion().node!.QID)
//        
//        handler.giveInput(input: "no", forNode: nil)
//        print(handler.getCurrentQuestion().question + " " + handler.getCurrentQuestion().node!.QID)
//        
//        handler.giveInput(input: "8", forNode: nil)
//        print(handler.getCurrentQuestion().question + " " + handler.getCurrentQuestion().node!.QID)
//        
//        handler.giveInput(input: "yes", forNode: (handler.currentQuestion as! LogicNode).firstN)
//        print(handler.getCurrentQuestion().question + " " + handler.getCurrentQuestion().node!.QID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupDetailView()
    }
    
    func setupDetailView() {
        if let _ = self.currentQuestion.node {
            switch self.currentQuestion.node!.type {
            case "BUTTON":
                let qv = DiscreteQuestionView(frame: self.questionView.bounds, question: self.currentQuestion.message)
                qv.delegate = self
                if let _ = currentView {
                    self.currentView.removeFromSuperview()
                }
                self.currentView = qv
                self.questionView.addSubview(qv)
                break
            case "NUMBER":
                let qv = RangeQuestionView(frame: self.questionView.bounds, question: self.currentQuestion.message)
                qv.delegate = self
                if let _ = currentView {
                    self.currentView.removeFromSuperview()
                }
                self.currentView = qv
                self.questionView.addSubview(qv)
                break
            case "OR":
                //use the logic node fn and sn to decide which nodes it is
                break
            case "UNKNOWN":
                break
            case "RESULT":
                break
            default:
                break
            }
        }
    }
    
    func discreteQuestionViewDidPressButton(sender: UIButton, pressed: Int) {
        if pressed == 0 || pressed == 1 {
            self.handler.giveInput(input: "yes", forNode: nil)
        }
        else {
            self.handler.giveInput(input: "no", forNode: nil)
        }
        let node = self.handler.getCurrentQuestion().node
        self.currentQuestion = (node, self.handler.getCurrentQuestion().question)
        self.setupDetailView()
    }
    
    func rangeQuestionViewDidPressButton(value: String) {
        print("here")
        self.handler.giveInput(input: value, forNode: nil)
        let node = self.handler.getCurrentQuestion().node
        self.currentQuestion = (node, self.handler.getCurrentQuestion().question)
        self.setupDetailView()
    }
}

