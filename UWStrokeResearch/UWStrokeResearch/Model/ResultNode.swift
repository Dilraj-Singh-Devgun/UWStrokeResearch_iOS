//
//  ResultNode.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 11/27/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//
//  for use with tags with the 'r' prefix instead of the 'q' prefix
//  this node type holds a mesage to display to the user in the question
//  field and has no connecting nodes
//  contains a phone number string and a researcher name for contacting
//  current valid types:
//  -UNKOWN
//  -RESULT
//

import Foundation

class ResultNode:Node {
    var phone:String!
    var researcher:String!
    
    init(qid: String, q: String, t: String) {
        super.init(nc: 0, qid: qid, q: q, t: t)
        self.phone = ""
        self.researcher = ""
    }
    
    init(qid: String, q: String, t: String, pnumber:String, r:String) {
        super.init(nc: 0, qid: qid, q: q, t: t)
        self.phone = pnumber
        self.researcher = r
    }
    
}
