//
//  HistoryList.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 1/30/17.
//  Copyright © 2017 Dilraj Devgun. All rights reserved.
//

import Foundation

struct HistoryList {
    // original IntStack implementation
    var items:[(Node,String)] = []
    mutating func add(_ item: (Node, String)) {
        items.append(item)
    }
    mutating func removeLast() -> (Node, String) {
        return items.removeLast()
    }
    func getCount() -> Int {
        return items.count;
    }
    mutating func getItems() -> [(Node, String)] {
        var itemsCopy:[(Node,String)] = []
        for i in 0..<items.count {
            itemsCopy.append(items[i])
        }
        return itemsCopy
    }
}
