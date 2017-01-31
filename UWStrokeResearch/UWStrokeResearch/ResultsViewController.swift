//
//  ResultsViewController.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 12/26/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    var handler:QuestionHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var history = self.handler.answerHistory.getItems()
        for (node, answer) in history {
            print("\(node.question)  + \(answer)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startOverButtonPressed(_ sender: Any) {
        
        //do some clearing on the previous view controller
        self.dismiss(animated: true, completion: nil)
    }
}
