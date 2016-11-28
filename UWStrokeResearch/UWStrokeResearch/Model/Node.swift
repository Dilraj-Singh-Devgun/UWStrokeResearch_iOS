//
//  Node.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 11/27/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//
//  A Node which outlines all the functionality that all other nodes will have.
//

import Foundation

class Node {
    var numConnected:Int! // number of nodes in the connections
    var QID:String! // QID of the file
    var question:String! // the question in string format
    var type:String! // the type of node
    
    init(nc:Int, qid:String, q:String, t:String) {
        self.numConnected = nc
        self.QID = qid
        self.question = q
        self.type = t
    }
}
