//
//  SubSumTests.swift
//  SubSumTests
//
//  Created by Donnacha Oisín Kidney on 28/08/2015.
//  Copyright © 2015 Donnacha Oisín Kidney. All rights reserved.
//

import XCTest

extension CollectionType where
  SubSequence : CollectionType,
  Generator.Element : IntegerType,
  SubSequence.Generator.Element == Generator.Element,
  SubSequence.SubSequence == SubSequence {
  func sumsTo(n: Generator.Element) -> Bool {
    if n < 0 { return false }
    if n == 0 { return true }
    guard let x = first else { return false }
    let t = dropFirst()
    return t.sumsTo(n - x) || t.sumsTo(n)
  }
}

func check(sum: Int, cards:[Int], target: Int) -> Bool {
  if sum == target { return true }
  if cards.isEmpty { return false }
  if sum > target { return false }
  
  for (index, card) in cards.enumerate() {
    var sublist = cards
    sublist.removeAtIndex(index)
    if check(sum + card, cards: sublist, target: target) {
      return true
    }
  }
  
  return false
}

func subsetsWithOneLessMemberThan(array:[Int]) -> [[Int]] {
  var o = [[Int]]()
  for i in 0..<array.count {
    var x = array
    x.removeAtIndex(i)
    o.append(x)
  }
  return o
}

func has10(array: [Int]) -> Bool {
  var found = false
  if array.count > 2 {
    let subarrays: [[Int]] = subsetsWithOneLessMemberThan(array)
    found = subarrays.reduce(found, combine: { return $0 || has10($1) })
  }
  
  return found || (array.reduce(0, combine: { $0 + $1 }) == 10)
}

func canAddTo(array: [Int], number: Int) -> Bool {
  return (0 ..< 1 << UInt64(array.count)).contains { (perm: UInt64) -> Bool in
    var sum = 0
    for (index, elem) in array.enumerate() where perm & 1 << UInt64(index) != 0 {
      sum += elem
      if sum >= 10 { break }
    }
    return sum == 10
  }
}


class SubSumTests: XCTestCase {
  
  let ars = (0...100000).map { _ in
    (1...5).map { _ in Int(arc4random_uniform(10)) }
  }
  
  func testSame() {
    
    let anss = ars.map(has10)
    
    XCTAssert(anss.contains { $0 } )
    
    for (ans, ar) in zip(anss, ars) {
      
      XCTAssert(check(0, cards: ar, target: 10) == ans)
      XCTAssert(ar.sumsTo(10) == ans)
      XCTAssert(canAddTo(ar, number: 10) == ans)
      
    }
    
  }
  
  
  func testOne() {
    self.measureBlock {
      for ar in self.ars {
        let x = ar.sumsTo(10)
        let _ = x
      }
    }
  }
  
  func testTwo() {
    self.measureBlock {
      for ar in self.ars {
        let x = check(0, cards: ar, target: 10)
        let _ = x
      }
    }
  }
  
  func testThree() {
    self.measureBlock {
      for ar in self.ars {
        let x = has10(ar)
        let _ = x
      }
    }
  }
  
  func testFour() {
    self.measureBlock {
      for ar in self.ars {
        let x = canAddTo(ar, number: 10)
        let _ = x
      }
    }
  }

}
