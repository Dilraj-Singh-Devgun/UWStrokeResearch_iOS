//
//  ViewController.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 11/27/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DiscreteQuestionViewDelegate, RangeQuestionViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var handler:QuestionHandler!
    var currentQuestion:(node: Node?, message:String)!
    var currentView:UIView!
    @IBOutlet weak var tableView: UITableView!
    var cellViews:[UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.handler = QuestionHandler()
        
        self.handler.giveInput(input: "start", forNode: nil)
        print(handler.getCurrentQuestion().question + " " + handler.getCurrentQuestion().node!.QID)
        let node = self.handler.getCurrentQuestion().node
        self.currentQuestion = (node, handler.getCurrentQuestion().question)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        cellViews = []
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupDetailView()
    }
    
    func setupDetailView() {
        if let _ = self.currentQuestion.node {
            var qv:UIView
            switch self.currentQuestion.node!.type {
            case "BUTTON":
                qv = DiscreteQuestionView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height: 200), question: self.currentQuestion.message)
                (qv as! DiscreteQuestionView).delegate = self
                if let _ = currentView {
                    self.currentView.removeFromSuperview()
                }
                self.cellViews.append(qv)
                break
            case "NUMBER":
                qv = RangeQuestionView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height: 200), question: self.currentQuestion.message)
                (qv as! RangeQuestionView).delegate = self
                if let _ = currentView {
                    self.currentView.removeFromSuperview()
                }
                self.cellViews.append(qv)
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
            self.tableView.reloadData()
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellViews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.addSubview(self.cellViews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

