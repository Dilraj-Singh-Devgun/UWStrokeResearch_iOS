//
//  QuestionHandler.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 12/3/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//

import Foundation

public class QuestionHandler {
    var currentQuestion:Node?
    var history:NodeStack!
    var parser:JSONParser!
    
    init() {
        //initialize the stack, json parser, and the root node
        self.history = NodeStack()
        self.parser = JSONParser()
        self.currentQuestion = parser.getNodeTree()
    }
    
    //returns the current question and the question/message of the current node
    func getCurrentQuestion() -> (node:Node?, question:String) {
        //if the current question is an OR return the 
        if self.currentQuestion?.type == "OR" {
            return (self.currentQuestion, ((self.currentQuestion as! LogicNode).firstN?.question!)! + " : " + ((self.currentQuestion as! LogicNode).secondN?.question!)!)
        }
        else if self.currentQuestion?.type == "RESULT" {
            let rn = self.currentQuestion as! ResultNode
            return (self.currentQuestion, rn.question + ". Please contact " + rn.researcher + " at " + rn.phone)
        }
        return (self.currentQuestion, (self.currentQuestion?.question!)!)
    }
    
    func getCurrentQuestionType() -> String {
        return (self.currentQuestion?.type)!
    }
    
    func goBackQuestion() {
        let lastQuestion = history.pop()
        self.currentQuestion = lastQuestion
    }
    
    //If current node is an OR node we must have a node passed in that will be the node that the input is for
    func giveInput(input:String, forNode:Node?) -> (nodes: Node?, message: String) {
        switch (self.currentQuestion?.type)! {
        case "NUMBER":
            let nextNumber = (self.currentQuestion as! RangeNode).nodeConnections
            if let answer = Int(input) {
                for (range, value) in nextNumber! {
                    if range.isBetween(value: answer) {
                        self.history.push(self.currentQuestion!)
                        self.currentQuestion = value
                        return (self.currentQuestion, (self.currentQuestion?.question)!)
                    }
                }
                return (nil, "Please enter a numeric value inside the specified range")
            }
            else {
                return (nil, "Please enter a numeric value")
            }
        case "BUTTON":
            let nextNodes = (self.currentQuestion as! DiscreteNode).nodeConnections
            let answer = input.lowercased()
            for (value, next) in nextNodes! {
                if (value == answer) {
                    self.history.push(self.currentQuestion!)
                    self.currentQuestion = next
                    return (self.currentQuestion, (self.currentQuestion?.question)!)
                }
            }
            return (nil, "Please select a valid response")
        case "OR":
            self.history.push(self.currentQuestion!)
            self.currentQuestion = moveORNode(input: input, node: forNode!)
            return (self.currentQuestion, (self.currentQuestion?.question)!)
        case "UNKNOWN":
            return (self.currentQuestion, "This does not require an answer")
        case "RESULT":
            return (self.currentQuestion, "This does not require an answer")
        default:
            return (nil, "This does not require an answer")
        }
    }
    
    func moveORNode(input:String, node:Node) -> Node? {
        switch node.type {
        case "NUMBER":
            let nextNumber = (node as! RangeNode).nodeConnections
            if let answer = Int(input) {
                for (range, value) in nextNumber! {
                    if range.isBetween(value: answer) {
                        return value
                    }
                }
                return nil
            }
            else {
                return nil
            }
        case "BUTTON":
            let nextNodes = (node as! DiscreteNode).nodeConnections
            let answer = input.lowercased()
            for (value, next) in nextNodes! {
                if (value == answer) {
                    return next
                }
            }
        case "OR": break
            //We have not handled the case where an or leads to another or question
        case "UNKNOWN":
            return node
        case "RESULT":
            return node
        default:
            return nil
        }
        return nil
    }
}
