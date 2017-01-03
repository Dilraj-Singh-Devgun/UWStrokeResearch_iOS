//: Playground - noun: a place where people can play

import UIKit

var arri = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11, 12, 13]

func search(arr:[Int], min: Int, max: Int, target:Int) -> Bool {
    
    if max < min {
        return false
    }
    
    let middle = ((max - min) / 2) + min
    
    if arr[middle] == target {
        return true
    }
    else if arr[middle] > target {
        return search(arr: arr, min: min, max: middle-1, target: target)
    }
    else {
        return search(arr: arr, min: middle+1, max: max, target: target)
    }
}

search(arr: arri, min: 0, max: arri.count - 1, target:100)
