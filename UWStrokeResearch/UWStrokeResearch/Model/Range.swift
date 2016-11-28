//
//  Range.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 11/27/16.
//  Copyright © 2016 Dilraj Devgun. All rights reserved.
//
// A range class to hold an upper and lower bound. The type can be either 
// equals or range. 'range' means the bounds are exlusive while 'equals' means
// the bounds are inclusive.
//

import Foundation

class Range:Hashable, Equatable{

    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int {
        return lowerBound.hashValue ^ (upperBound.hashValue &* type.hashValue)
    }

    var lowerBound:Int = Int.min
    var upperBound:Int = Int.max
    var type:String!
    
    init(lower:String, upper:String, t:String) {
        if lower != "MIN" {
            self.lowerBound = Int(lower)!
        }
        if upper != "MAX" {
            self.upperBound = Int(upper)!
        }
        self.type = t
        
    }
    
    init(value:String) {
        self.lowerBound = Int(value)!
        self.upperBound = Int(value)!
        self.type = "EQUALS"
    }
    
    func isBetween(value:Int) -> Bool {
        if self.type == "RANGE" {
            return (value > self.lowerBound && value < self.upperBound)
        }
        else if self.type == "EQUALS" {
            return (value >= self.lowerBound && value <= self.upperBound)
        }
        else {
            return false
        }
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Range, rhs: Range) -> Bool {
        if lhs.type == rhs.type {
            if lhs.upperBound == rhs.upperBound && lhs.lowerBound == rhs.lowerBound{
                return true
            }
        }
        return false
    }
}
