//
//  JSONparser.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 12/3/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//

import Foundation
import UIKit

public class JSONParser {
    
    
    
    //Constructs a node tree by going through the json file
    func getNodeTree() -> Node?{
        var jsn:JSON?
        //get the path of the json file  and if we can exract the data from it make our json object
        if let path = Bundle.main.path(forResource: "decision_tree_updated", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                jsn = JSON(data: data as Data, options: .allowFragments, error: nil)
            }
        }
        return processJsn(jsn: jsn)
    }
    
    func getNodeTree(jsnString: String) -> Node? {
        var jsn: JSON?
        
        
//        if let data = NSData(contentsOfFile: jsnString) {
        if let data = jsnString.data(using: .utf8) {
            print(data)
            jsn = JSON(data: data, options: .allowFragments, error: nil)
        }
        return processJsn(jsn: jsn)
    }
    
    func processJsn(jsn: JSON?) -> Node? {
        var root:Node?
        
        //if the json object is not null then the json file has been properly loaded using swiftyjson
        if let json = jsn {
            print("json loaded")
            print()
            
            if json["file"] != JSON.null {
                //start at the base node of q000
                let unwrappedJSON = JSON(data: (json["file"].string!.data(using: .utf8))!, options: .allowFragments, error: nil)
                if unwrappedJSON["q000"] != JSON.null{
                    print("here3")
                    root = processNode(QID: "q000", json: unwrappedJSON)
                }
            }
        }
        else {
            print("failed")
        }
        //return the top of the tree
        return root
    }
    
    //processes logic nodes recursively following pathways from each json branch
    func processNode(QID:String, json:JSON) -> Node? {
        //get the type field of the json object
        let type = json[QID]["type"].string!
        print(QID + " " + type)
        
        //base case return result node
        if QID.characters.first == "r" {
            let message = json[QID]["message"].string!
            let phoneNum = json[QID]["phone"].string!
            return ResultNode(qid: QID, q: message, t: type, pnumber: phoneNum, r: "Call Glenn Schubert")
        }
        //switch on the type
        switch type {
        case "NUMBER":
            //get the options associated with the json object
            let options = json[QID]["options"].array!
            let opts = json[QID]["options"]
            //get the question for the json object
            let question = json[QID]["question"].string!
            //make a range node using the question and the options count
            let rangeNode = RangeNode(nc: options.count, qid: QID, q: question)
            //for every option we want to recursively process nodes and make the associated nodes that are to be connected to the current node
            for i in 0 ..< options.count {
                if opts[i]["type"] == "RANGE"{
                    rangeNode.addRangeNode(lower: opts[i]["lower"].rawString()!, upper: opts[i]["upper"].rawString()!, type: opts[i]["type"].string!, next: processNode(QID: opts[i]["next"].string!, json: json))
                }
                else{
                    rangeNode.addEqualsNode(value: opts[i]["value"].rawString()!, next: processNode(QID: opts[i]["next"].string!, json: json))
                }
            }
            return rangeNode
        case "BUTTON":
            //get the option field of the json object
            let options = json[QID]["options"].array!
            let opts = json[QID]["options"]
            //get the question for the json object
            let question = json[QID]["question"].string!
            //create a discrete node with the question and options count
            let discreteNode = DiscreteNode(nc: options.count, qid: QID, q: question)
            //for everything in the options count loop through and add a node to the discrete node object
            for i in 0 ..< options.count {
                discreteNode.addNode(option: opts[i]["value"].string!, next: processNode(QID: opts[i]["next"].string!, json: json))
            }
            return discreteNode
        case "OR":
            //get the next question of the json object
            let next = json[QID]["question"].array!
            let nextQs = json[QID]["question"]
            //make a logic node with the processed nodes connected
            return LogicNode(nc: next.count, qid: QID, q: "", t: "OR", fn: processNode(QID: nextQs[0].string!, json: json), sn: processNode(QID: nextQs[1].string!, json: json))
        default:
            print("illegal type")
        }
        return nil
    }
}
