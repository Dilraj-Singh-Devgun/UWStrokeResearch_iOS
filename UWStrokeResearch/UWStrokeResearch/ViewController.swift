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
    @IBOutlet weak var markerView: UIView!
    @IBOutlet weak var markerViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.handler = QuestionHandler()
        
        let node = self.handler.giveInput(input: "start", forNode: nil).nodes
        print(handler.getCurrentQuestion().question + " " + handler.getCurrentQuestion().node!.QID)
        self.currentQuestion = (node, handler.getCurrentQuestion().question)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        cellViews = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupDetailView()
    }
    
    override func viewDidLayoutSubviews() {
        //self.setupDetailView()
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
            self.updateTableView()
        }
    }
    
    func discreteQuestionViewDidPressButton(sender: UIButton, pressed: Int) {
        var node:Node?
        if pressed == 0 || pressed == 1 {
            node = self.handler.giveInput(input: "yes", forNode: nil).nodes
        }
        else {
            node = self.handler.giveInput(input: "no", forNode: nil).nodes
        }
        self.currentQuestion = (node, self.handler.getCurrentQuestion().question)
        self.setupDetailView()
    }
    
    func rangeQuestionViewDidPressButton(value: String) {
        print("here")
        let node = self.handler.giveInput(input: value, forNode: nil).nodes
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
    
    func updateContentInsetForTableView(tableView:UITableView, animated:Bool) {
        let lastRow = self.tableView.numberOfRows(inSection: 0)
        let lastIndex = lastRow > 0 ? lastRow - 1 : 0
        let lastIndexPath = IndexPath(item: lastIndex, section: 0)
        let lastCellFrame = self.tableView.rectForRow(at: lastIndexPath)
        let topInset = max(self.tableView.frame.height - lastCellFrame.origin.y - lastCellFrame.height, 0)
        var contentInset = tableView.contentInset
        contentInset.top = topInset
        let options = UIViewAnimationOptions.beginFromCurrentState
        UIView.animate(withDuration: animated ? 0.25 : 0, delay: 0, options: options, animations: {() in
            self.markerViewHeightConstraint.constant = abs(topInset)
            tableView.contentInset = contentInset
            self.markerView.setNeedsLayout()
            self.markerView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func updateTableView() {
        let indexPath = IndexPath(item: (self.cellViews.count - 1), section: 0)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        self.tableView.endUpdates()
        self.updateContentInsetForTableView(tableView: self.tableView, animated: true)
        self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
}

