//
//  AnswerTableViewCell.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 1/30/17.
//  Copyright © 2017 Dilraj Devgun. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setQuestionAndAnswer(question:String, answer:String) {
        self.questionLabel.text = question
        self.answerLabel.text = answer
        self.questionLabel.sizeToFit()
        self.answerLabel.sizeToFit()
    }
}
