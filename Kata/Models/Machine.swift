//
//  Machine.swift
//  Kata
//
//  Created by MCS Devices on 1/23/18.
//  Copyright © 2018 MCS Devices. All rights reserved.
//

import UIKit

struct Machine {
  
  static let stack = UserDefaults.standard
  static let stackKey = "Stock"
  static let balanceKey = "Balance"
  
  static func checkBalance(key: String) -> Double {
    return (Machine.stack.object(forKey: key) as? [Double] ?? [Double]()).reduce(0, {$0 + $1})
  }
  
  static func insertCoin(coin: Coin) throws {
    var coins = stack.object(forKey: balanceKey) as? [Double] ?? [Double]()
    if coin != .Penny {
      coins.append(coin.rawValue)
      coins.sort(by: { $0 > $1})
      stack.set(coins, forKey: balanceKey)
    } else {
      throw VendingMachineError.invalidCoin
    }
  }
  
  static func getBalance(key: String) -> [Double] {
    return Machine.stack.object(forKey: key) as? [Double] ?? [Double]()
  }
  
  
  static func makeChange(value: Double) throws -> [Double] {
    guard value > 0 else { return [] }
    var result: [Double] = []
    var valueCopy = value
    let stack = getBalance(key: Machine.stackKey)
    
    for coin in stack {
      while valueCopy - coin >= 0 {
        result.append(coin)
        valueCopy -= coin
      }
      
      if valueCopy == 0 {
        break
      }
    }
    
    if valueCopy > 0 {
      throw VendingMachineError.insufficientFunds(valueNeeded: valueCopy)
    }
    
    return result
  }
  
}
