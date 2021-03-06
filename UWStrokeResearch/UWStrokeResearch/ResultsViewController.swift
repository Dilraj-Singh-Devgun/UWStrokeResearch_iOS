//
//  ResultsViewController.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 12/26/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//

import UIKit

protocol ResultsViewControllerDelegate {
    func didGoBackToMainMenu()
}

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var phoneNumberField: UITextView!
    @IBOutlet weak var researcherNameLabel: UILabel!
    @IBOutlet weak var researchTrialLabel: UILabel!
    @IBOutlet weak var answerTableView: UITableView!
    @IBOutlet weak var eligabilityMessage: UITextView!
    var handler:QuestionHandler!
    var delegate:ResultsViewControllerDelegate?
    var history:[(node:Node, answer:String)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.answerTableView.delegate = self
        self.answerTableView.dataSource = self
        self.setLabelText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mainMenuButtonPrssed(_ sender: Any) {
        if let _ = self.delegate {
            self.delegate?.didGoBackToMainMenu()
        }
    }
    
    func setValuesPerformSetup(){
        self.history = self.handler.answerHistory.getItems()
        self.history.remove(at: 0)
    }
    
    func setLabelText() {
        let currNode = self.handler.currentQuestion
        if currNode?.type == "UNKNOWN" {
            self.eligabilityMessage.text = "No Studies Available"
            self.phoneNumberField.text = ""
            self.researcherNameLabel.text = ""
            self.researchTrialLabel.text = ""
            return
        }
        self.researcherNameLabel.adjustsFontSizeToFitWidth = true
        self.researchTrialLabel.adjustsFontSizeToFitWidth = true
        
        self.phoneNumberField.text = (currNode as! ResultNode).phone
        self.researcherNameLabel.text = (currNode as! ResultNode).researcher
        self.researchTrialLabel.text = currNode?.question
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = answerTableView.dequeueReusableCell(withIdentifier: "answerCell") as! AnswerTableViewCell
        let curr = self.history[indexPath.row]
        cell.setQuestionAndAnswer(question: curr.node.question, answer: curr.answer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
