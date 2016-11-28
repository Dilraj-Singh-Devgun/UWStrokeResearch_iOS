//
//  DiscreteNode.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 11/27/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//  For use with the BUTTON tag in the json file.
//  Contains a map linking phrases for buttons to connection nodes QIDs.
//  Also contains a map of phrases for buttons to Nodes
//

import Foundation

class DiscreteNode: Node {
    var connections:[String:String]!
    var nodeConnections:[String: Node]!
    
    init(nc: Int, qid: String, q: String) {
        super.init(nc: nc, qid: qid, q: q, t: "BUTTON")
        self.connections = [:]
        self.nodeConnections = [:]
    }
    
    func addNode(option:String, next:String) {
        self.connections.updateValue(next, forKey: option)
    }
    
    func addNode(option:String, next:Node) {
        self.nodeConnections.updateValue(next, forKey: option)
    }
    
}
