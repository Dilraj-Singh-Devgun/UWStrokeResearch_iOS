//
//  LogicNode.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 11/27/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//
//  Node for questions that evaluate logical expressions and then 
//  evaluate to a binary decision
//  has a first and second option field corresponding to the left and
//  right hand of a logical expression respectively
//  also has a first and second node connection
//

import Foundation

class LogicNode:Node {
    
    var first:String?
    var second:String?
    var firstN:Node?
    var secondN:Node?
    
    override init(nc:Int, qid:String, q:String, t:String) {
        super.init(nc: nc, qid: qid, q: q, t: t)
        self.first = nil
        self.second = nil
        self.firstN = nil
        self.secondN = nil
    }
    
    init(nc:Int, qid:String, q:String, t:String, f:String, s:String) {
        super.init(nc: nc, qid: qid, q: q, t: t)
        self.first = f
        self.second = s
        self.firstN = nil
        self.secondN = nil
    }
    
    init(nc: Int, qid: String, q: String, t: String, fn:Node, sn:Node) {
        super.init(nc: nc, qid: qid, q: q, t: t)
        self.first = nil
        self.second = nil
        self.firstN = fn
        self.secondN = sn
    }
}
