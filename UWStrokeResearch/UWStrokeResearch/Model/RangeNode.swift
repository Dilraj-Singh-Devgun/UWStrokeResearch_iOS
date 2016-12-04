//
//  RangeNode.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 11/27/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//
//  The class for a node where the user inputs a number on a scale 
//  and it is checked to see if it fits within a certain range.
//  contains a map where certain range instances are connected to 
//  corresponding QIDs. Also contains a map where ranges map to Nodes.
//

import Foundation

class RangeNode:Node {
    
    var connections:[Range: String]!
    var nodeConnections:[Range: Node?]!
    
    init(nc:Int, qid:String, q:String){
        super.init(nc: nc, qid: qid, q: q, t: "NUMBER")
        self.connections = [:]
        self.nodeConnections = [:]
    }
    
    func addRangeNode(lower:String, upper:String, type:String, next:String) {
        let range = Range(lower: lower, upper: upper, t: type)
        self.connections.updateValue(next, forKey: range)
    }
    
    func addRangeNode(lower:String, upper:String, type:String, next:Node?) {
        let range = Range(lower: lower, upper: upper, t: type)
        self.nodeConnections.updateValue(next, forKey: range)
    }
    
    func addEqualsNode(value:String, next:String) {
        let equals = Range(value: value)
        self.connections.updateValue(next, forKey: equals)
    }
    
    func addEqualsNode(value:String, next:Node?) {
        let equals = Range(value: value)
        self.nodeConnections.updateValue(next, forKey: equals)
    }
}
