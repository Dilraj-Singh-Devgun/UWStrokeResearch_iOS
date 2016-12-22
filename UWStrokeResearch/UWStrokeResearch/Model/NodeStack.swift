//
//  NodeStack.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 12/3/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//

import Foundation

struct NodeStack {
    // original IntStack implementation
    var items = [Node]()
    mutating func push(_ item: Node) {
        items.append(item)
    }
    mutating func pop() -> Node {
        return items.removeLast()
    }
}
