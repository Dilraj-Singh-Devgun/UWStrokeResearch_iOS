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
        //if the current question is a result we want to return the contact information of the research
        else if self.currentQuestion?.type == "RESULT" {
            let rn = self.currentQuestion as! ResultNode
            return (self.currentQuestion, rn.question + ". Please contact " + rn.researcher + " at " + rn.phone)
        }
        //if the current question is a different node type get the single message of one node and then return that node with the message
        return (self.currentQuestion, (self.currentQuestion?.question!)!)
    }
    
    //returns the type of the current question
    func getCurrentQuestionType() -> String {
        return (self.currentQuestion?.type)!
    }
    
    //goes to the previous question
    func goBackQuestion() {
        //pops the last question of the stack
        let lastQuestion = history.pop()
        //sets the current question to the previous question
        self.currentQuestion = lastQuestion
    }
    
    //If current node is an OR node we must have a node passed in that will be the node that the input is for
    func giveInput(input:String, forNode:Node?) -> (nodes: Node?, message: String) {
        //switch based on the current question type
        switch (self.currentQuestion?.type)! {
        case "NUMBER":
            //get the dictionary of possible offshoots of the current node with the input that will take it there
            let nextNumber = (self.currentQuestion as! RangeNode).nodeConnections
            //attempt to cast the answer as an int
            if let answer = Int(input) {
                //loop through the dictionary of connections and its ranges that are associated with it
                for (range, value) in nextNumber! {
                    //if our input falls within the current range then push our current question onto the stack, make our current question node associated with the range and return a tuple of the node and the question
                    if range.isBetween(value: answer) {
                        self.history.push(self.currentQuestion!)
                        self.currentQuestion = value
                        return (self.currentQuestion, (self.currentQuestion?.question)!)
                    }
                }
                //if our range does not fall within the ranges specified we return null and the message to enter a numeric value
                return (nil, "Please enter a numeric value inside the specified range")
            }
            //if we cannot cast the input as an int return null and prompt for a numeric value
            else {
                return (nil, "Please enter a numeric value")
            }
        case "BUTTON":
            //get a dictionary of possible offshoot nodes
            let nextNodes = (self.currentQuestion as! DiscreteNode).nodeConnections
            //make our input lower case
            let answer = input.lowercased()
            //loop through every value and node in the next node dictionary
            for (value, next) in nextNodes! {
                //if the user's input matches the value in our dictionary the we have found our associated node and we push the current question onto the stack, set the current question to the associated node and then return the new node and the question
                if (value == answer) {
                    self.history.push(self.currentQuestion!)
                    self.currentQuestion = next
                    return (self.currentQuestion, (self.currentQuestion?.question)!)
                }
            }
            //if we fail to find a node associated with the user's response then we prompt the user to enter a valid response
            return (nil, "Please select a valid response")
        case "OR":
            //push the current question onto the stack
            self.history.push(self.currentQuestion!)
            //set the current question to the value returned by the moveORNode method
            self.currentQuestion = moveORNode(input: input, node: forNode!)
            //return the current question and the message associated with it
            return (self.currentQuestion, (self.currentQuestion?.question)!)
        case "UNKNOWN":
            //unknown node types do not require input
            return (self.currentQuestion, "This does not require an answer")
        case "RESULT":
            //result node types do not require input
            return (self.currentQuestion, "This does not require an answer")
        default:
            //does not require input
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
