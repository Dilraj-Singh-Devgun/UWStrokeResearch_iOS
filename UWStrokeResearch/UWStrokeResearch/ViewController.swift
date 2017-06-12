//
//  ViewController.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 11/27/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DiscreteQuestionViewDelegate, RangeQuestionViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, LogicQuestionViewDelegate, ResultsViewControllerDelegate, ModularButtonViewDeleate, DatabaseProtocol {

    var handler:QuestionHandler! // the question node handler which traverses our tree
    var currentQuestion:(node: Node?, message:String)! // a tuple which holds the current node and question
    @IBOutlet weak var tableView: UITableView! // the tableview which will display all the question
    var cellViews:[UIView]! //All the question views which have been asked in the table view; includes the current question.
    @IBOutlet weak var markerView: UIView! // the padding at the top of the table view which will allow us to aact as if we are adding views from the bottom up
    @IBOutlet weak var markerViewHeightConstraint: NSLayoutConstraint! // the constraint which controls the height of the marker view which we animate
    @IBOutlet weak var tableViewTopLayoutConstraint: NSLayoutConstraint!
    var firstLoad:Bool = true
    @IBOutlet weak var markerViewTopLayoutConstraint: NSLayoutConstraint!

// MARK: ViewController setup and UIViewController overridden methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DatabaseConnection.makeGetRequestForJSONFile(callback: self)
        
        //basic setup for
        // create the handler, get the current node and set up the table view's delegate and data source
//        self.handler = QuestionHandler()
//        let node = self.handler.giveInput(input: "start", forNode: nil).nodes
//        self.currentQuestion = (node, handler.getCurrentQuestion().question)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        cellViews = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if firstLoad == true {
//            self.setupDetailView()
//        }
//        self.firstLoad = false
    }
    
    func databaseSetupCallback(response: String?) {
        
        DispatchQueue.main.async {
            if let _ = response {
                print(response)
                self.handler = QuestionHandler(jsonString: response!)
                if let _ = self.handler.getCurrentQuestion().node {
                    let node = self.handler.giveInput(input: "start", forNode: nil).nodes
                    self.currentQuestion = (node, self.handler.getCurrentQuestion().question)
                    if self.firstLoad == true {
                        self.setupDetailView()
                    }
                    self.firstLoad = false
                }
                else {
                    self.presentErrorParsingDatabaseFile()
                }
            }
            else {
                self.presentErrorParsingDatabaseFile()
            }
            print("here")
        }
    }
    
    func presentErrorParsingDatabaseFile() {
        let alert = UIAlertController(title: "Error", message: "Could not get data from database", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //sets up the next view to be put in the tableview based on the new node
    func setupDetailView() {
        if let _ = self.currentQuestion.node {
            var qv:UIView
            switch self.currentQuestion.node!.type {
            case "BUTTON":
                //if the new node is a button type then we make a DiscreteQuestionView with the delegate set to self. Once made we update the table view to display all the cells and introduce the new question
                qv = ModularButtonView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height: 200), question: self.currentQuestion.message)
                let options = (self.currentQuestion.node! as! DiscreteNode).nodeConnOptions
//                var bttnOptions:[String] = []
//                for (value, _) in options! {
//                    bttnOptions.append(value)
//                }
                (qv as! ModularButtonView).setButtons(buttons: options!, width: self.view.frame.width)
                (qv as! ModularButtonView).delegate = self
//                qv = DiscreteQuestionView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height: 200), question: self.currentQuestion.message)
//                (qv as! DiscreteQuestionView).delegate = self
                self.cellViews.append(qv)
                self.updateTableView()
                break
            case "NUMBER":
                //if the new node is a number type then we make a RangeQuestionView with the delegate set to self. Once made we update the table view to display all the cells and introduce the new question
                qv = RangeQuestionView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height: 250), question: self.currentQuestion.message)
                (qv as! RangeQuestionView).delegate = self
                self.cellViews.append(qv)
                self.updateTableView()
                break
            case "OR":
                //use the logic node fn and sn to decide which nodes it is
                qv = LogicQuestionView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height: 400))
                let currentNode = self.currentQuestion.node! as! LogicNode
                let subframe = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
                (qv as! LogicQuestionView).setQuestions(node1: currentNode.firstN!, node2: currentNode.secondN!, frame: subframe)
                (qv as! LogicQuestionView).delegate = self
                self.cellViews.append(qv)
                self.updateTableView()
                //if the new node is an OR type then we make a LogicQuestionView which will make both question input views that are needed for it. Once made we update the table view to display all the cells and introduce the new question
                break
            case "UNKNOWN":
                //currently an unknown node goes to show that no known research is available
                let rvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resultVC")
                (rvc as! ResultsViewController).handler = self.handler
                (rvc as! ResultsViewController).delegate = self
                (rvc as! ResultsViewController).setValuesPerformSetup()
                self.present(rvc, animated: true, completion: nil)
                break
            case "RESULT":
                //we push the ResultsViewController to the screen
                //We need to send the data for the research over so it can be displayed.
                let rvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resultVC")
                (rvc as! ResultsViewController).handler = self.handler
                (rvc as! ResultsViewController).delegate = self
                (rvc as! ResultsViewController).setValuesPerformSetup()
                self.present(rvc, animated: true, completion: nil)
                break
            default:
                break
            }
        }
        else {
            let alert = UIAlertController(title: "Invalid Input", message: self.currentQuestion!.message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.draggedUp = true
            self.handleDraggedUp()
        }
    }
    
    
// MARK: ResultsViewControllerDelegate Methods 
    func didGoBackToMainMenu() {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
// MARK: ModularButtonViewDelegateMethods
    func modularButtonViewTappedInactive(sender: ModularButtonView) {
        
    }
    
    func modularButtonViewViewDidPressButton(sender: UIButton, pressed: Int, view: UIView, options: [String]) {
        var node:Node?
        node = self.handler.giveInput(input: options[pressed-1], forNode: nil).nodes
        self.currentQuestion = (node, self.handler.getCurrentQuestion().question)
        let currView = self.cellViews.last
        (currView as! ModularButtonView).setInactive()
        self.setupDetailView()
    }
    
    
// MARK: DiscreteQuestionViewDelegate Methods
    
    //When a button in a discrete view question has been pressed we move the node and load a new view into the tableview
    func discreteQuestionViewDidPressButton(sender: UIButton, pressed: Int, view:UIView) {
        var node:Node?
        if pressed == 1 || pressed == 2 {
            node = self.handler.giveInput(input: "yes", forNode: nil).nodes
        }
        else {
            node = self.handler.giveInput(input: "no", forNode: nil).nodes
        }
        self.currentQuestion = (node, self.handler.getCurrentQuestion().question)
        let currView = self.cellViews.last
        (currView as! DiscreteQuestionView).setInactive()
        self.setupDetailView()
    }
    
    func discreteQestionViewTappedInactive(sender: DiscreteQuestionView) {
        //scroll to index 
        //remove old view
        //make active
    }
    
// MARK: RangeQuestionViewDelegate Methods
    
    //When a range is entered we move the node based on the user's input and load the next question for the client
    func rangeQuestionViewDidPressButton(value: String, view:UIView) {
        let output = self.handler.giveInput(input: value, forNode: nil)
        let node = output.nodes
        let message = output.message
        self.currentQuestion = (node, message)
        let currView = self.cellViews.last
        (currView as! RangeQuestionView).setInactive()
        self.setupDetailView()
    }
    
    func rangeQestionViewTappedInactive(sender: RangeQuestionView) {
        //scroll to index
        //remove old view
        //make active
    }
    
    //When the keyboard drops we can move the tableview back to its original position
    func rangeTextViewDidEndEditing(sender: Any) {
        self.animateTableViewToDefaultPosition()
    }
    
    //Move tableview up when there is a keyboard so the user can see the button and all of the field
    func rangeTextViewDidBeginEditing(sender: Any) {
        self.animateAboveTextField()
    }
    
    func rangeQuestionViewNeedsAlert(sender: Any, alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    var displacement:CGFloat?
    func animateAboveTextField() {
        UIView.animate(withDuration: 0.3, animations: {() in
            self.tableViewTopLayoutConstraint.constant = -220
            self.markerViewTopLayoutConstraint.constant = -220
            self.markerView.setNeedsLayout()
            self.markerView.layoutIfNeeded()
            self.tableView.setNeedsLayout()
            self.tableView.layoutIfNeeded()
            //self.updateTableView()
        })
    }
    
    func animateTableViewToDefaultPosition() {
        UIView.animate(withDuration: 0.5, animations: {() in
            self.tableViewTopLayoutConstraint.constant = 0;
            self.markerViewTopLayoutConstraint.constant = 0
            self.markerView.setNeedsLayout()
            self.markerView.layoutIfNeeded()
            self.tableView.setNeedsLayout()
            self.tableView.layoutIfNeeded()
            //self.updateTableView()
        })
    }
    
// MARK: LogicQuestionViewNodeDelegate Methods 
    func logicQuestoinViewStoppedEditing() {
        self.animateTableViewToDefaultPosition()
    }
    
    func logicQuestionViewBeganEditing() {
        self.animateAboveTextField()
    }
    
    func logicQuestionViewTappedInactive() {
        //scroll to index
        //remove old view
        //make active
    }
    
    func logicQuestionViewRangeAnswered(node: Node, value: String) {
        let nextNode = self.handler.giveInput(input: value, forNode: node).nodes
        self.currentQuestion = (nextNode, self.handler.getCurrentQuestion().question)
        let currView = self.cellViews.last
        (currView as! LogicQuestionView).setInactive()
        self.setupDetailView()
    }
    
    func logicQuestionViewDiscreteAnswered(node: Node, sender: UIButton, pressed: Int) {
        var nextNode:Node?
        if pressed == 1 || pressed == 2 {
            nextNode = self.handler.giveInput(input: "yes", forNode: node).nodes
        }
        else {
            nextNode = self.handler.giveInput(input: "no", forNode: node).nodes
        }
        self.currentQuestion = (nextNode, self.handler.getCurrentQuestion().question)
        let currView = self.cellViews.last
        (currView as! LogicQuestionView).setInactive()
        self.setupDetailView()
    }
    
    func logicQuestionViewModularAnswered(node: Node, sender: UIButton, pressed: Int, options: [String]) {
        var node:Node?
        node = self.handler.giveInput(input: options[pressed-1], forNode: nil).nodes
        self.currentQuestion = (node, self.handler.getCurrentQuestion().question)
        let currView = self.cellViews.last
        (currView as! LogicQuestionView).setInactive()
        self.setupDetailView()
    }
    
    func logicQuestionViewNeedsToPresentAlert(sender: Any, alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    

// MARK: UITableViewDelegate and UITableViewDataSource Methods
    
    //Returns the number of questions in the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellViews.count
    }
    
    //Returns the cell for the index in the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.addSubview(self.cellViews[indexPath.row])
        return cell
    }
    
    //returns the height for the row in the tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellViews[indexPath.row].frame.height
    }
    
    //Handles the buffer at the top of the tableview to allow for cells to display from the bottom up
    func updateContentInsetForTableView(tableView:UITableView, animated:Bool) {
        //grab the last row in the tableivew
        let lastRow = self.tableView.numberOfRows(inSection: 0)
        //gets whether the last row is greater than 0. If it is then we get the last index otherwise 0
        let lastIndex = lastRow > 0 ? lastRow - 1 : 0
        //Using the index we get the indexpath for the row
        let lastIndexPath = IndexPath(item: lastIndex, section: 0)
        //We then get the frame of the last cell
        let lastCellFrame = self.tableView.rectForRow(at: lastIndexPath)
        //the top inset is calculated as the height between the last cell and the top of the tableview frame and whether there should be a buffer at the top or it should be 0.
        let topInset = max(self.tableView.frame.height - lastCellFrame.origin.y - lastCellFrame.height, 0)
        //We get the current content inset of tableview
        var contentInset = tableView.contentInset
        //We then set the top inset to our newly calculated topinset and animate the new inset in so it doesn't simply snap
        contentInset.top = topInset
        let options = UIViewAnimationOptions.beginFromCurrentState
        UIView.animate(withDuration: animated ? 0.25 : 0, delay: 0, options: options, animations: {() in
            self.markerViewHeightConstraint.constant = abs(topInset)
            tableView.contentInset = contentInset
            self.markerView.setNeedsLayout()
            self.markerView.layoutIfNeeded()
        }, completion: nil)
    }
    
    //When the tableview needs to display a new view this method is called to handle the display from the bottom up
    func updateTableView() {
        //We get the indexpath and then begin updates to insert the row and then update the content inset using our method and then we scroll to the bottom.
        let indexPath = IndexPath(item: (self.cellViews.count - 1), section: 0)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        self.tableView.endUpdates()
        self.updateContentInsetForTableView(tableView: self.tableView, animated: true)
        self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    //Handles deleting the last element and moving the elements downwards
    func updateTableViewDeletion() {
        //if there is more than one element then delete it go back an element and then update the tableview
        if self.cellViews.count > 1 {
            self.cellViews.removeLast()
            self.handler.goBackQuestion()
            let node = self.handler.currentQuestion
            self.currentQuestion = (node, self.handler.getCurrentQuestion().question)
            if let v = self.cellViews.last as? RangeQuestionView {
                v.setActive()
            }
            else if let v = self.cellViews.last as? DiscreteQuestionView {
                v.setActive()
            }
            else if let v = self.cellViews.last as? LogicQuestionView{
                v.setActive()
            }
            else if let v = self.cellViews.last as? ModularButtonView {
                v.setActive()
            }
            self.tableView.reloadData()
            self.updateContentInsetForTableView(tableView: self.tableView, animated: true)
            let indexPath = IndexPath(item: self.cellViews.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
        else if self.cellViews.count == 1 {
            //Otherwise set the first question to be active again
            if let v = self.cellViews.last as? RangeQuestionView {
                v.setActive()
            }
            else if let v = self.cellViews.last as? DiscreteQuestionView {
                v.setActive()
            }
        }
        draggedUp = false
    }
    
    
// MARK: UIScrollViewDelegate Methods
    
    //When the scrolling begins to slow we want to snap to the above cell
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        //If the user drags down then set it to true
        if scrollView.panGestureRecognizer.velocity(in: scrollView).y > 800 {
            self.draggedUp = true
        }
        setContentOffset(scrollView: scrollView)
    }

    var draggedUp:Bool = false
    //When the user finishes dragging we also want to scroll to the cell above unless we have already been doing so with the deceleration methods
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        draggedUp = true
        guard !decelerate else {
            return
        }
        setContentOffset(scrollView: scrollView)
    }
    
    
    //We find our displacement value by dividing the height by the height of our cells and then we move upward to it.
    func setContentOffset(scrollView: UIScrollView) {
        let stopOver = scrollView.contentSize.height / (self.cellViews.last?.frame.height)! //scrollView.contentSize.height / CGFloat(numOfItems) // potentially: scrollView.contentSize.height / self.cellViews.last.frame.height
        let y = round(scrollView.contentOffset.y / stopOver) * stopOver
        guard y >= 0 && y <= scrollView.contentSize.height - scrollView.frame.height else {
            self.handleDraggedUp()
            return
        }
        scrollView.setContentOffset(CGPoint(x:scrollView.contentOffset.x, y:y), animated: true)
        self.handleDraggedUp()
    }
    
    //
    func handleDraggedUp() {
        if self.draggedUp {
            self.updateTableViewDeletion()
            draggedUp = false
        }
    }
}
