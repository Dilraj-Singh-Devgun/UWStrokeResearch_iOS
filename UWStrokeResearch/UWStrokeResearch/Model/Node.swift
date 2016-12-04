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

class Node: Hashable, Equatable{
    
    public var hashValue: Int {
        return QID.hashValue ^ question.hashValue
    }
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
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Node, rhs: Node) -> Bool {
        if lhs.hashValue == rhs.hashValue {
            return true
        }
        return false
    }
    
}
