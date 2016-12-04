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
    
    func getNodeTree() -> Node?{
        var root:Node?
        var jsn:JSON?
        
        if let path = Bundle.main.path(forResource: "stroke_trial_decision_tree", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                jsn = JSON(data: data as Data, options: .allowFragments, error: nil)
            }
        }
        
        if let json = jsn {
            print("json loaded")
            print()
            if json["q000"] != JSON.null{
                root = processNode(QID: "q000", json :json)
            }
        }
        else {
            print("failed")
        }
        return root
    }
    
    func processNode(QID:String, json:JSON) -> Node? {
        let type = json[QID]["type"].string!
        print(QID + " " + type)
        
        //base case return result node
        if QID.characters.first == "r" {
            let message = json[QID]["message"].string!
            return ResultNode(qid: QID, q: message, t: type)
        }
        switch type {
        case "NUMBER":
            let options = json[QID]["options"].array!
            let opts = json[QID]["options"]
            let question = json[QID]["question"].string!
            let rangeNode = RangeNode(nc: options.count, qid: QID, q: question)
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
            let options = json[QID]["options"].array!
            let opts = json[QID]["options"]
            let question = json[QID]["question"].string!
            let discreteNode = DiscreteNode(nc: options.count, qid: QID, q: question)
            for i in 0 ..< options.count {
                discreteNode.addNode(option: opts[i]["value"].string!, next: processNode(QID: opts[i]["next"].string!, json: json))
            }
            return discreteNode
        case "OR":
            let next = json[QID]["question"].array!
            let nextQs = json[QID]["question"]
            return LogicNode(nc: next.count, qid: QID, q: "", t: "OR", fn: processNode(QID: nextQs[0].string!, json: json), sn: processNode(QID: nextQs[1].string!, json: json))
        default:
            print("illegal type")
        }
        
        return nil
    }
}
