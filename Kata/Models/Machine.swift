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
  static let trayKey = "Tray"
  static let productsKey = "Products"
  
  
  static func checkStack(key: String) -> Double {
    return (Machine.stack.object(forKey: key) as? [Double] ?? [Double]()).reduce(0, {$0 + $1})
  }
  
  static func getStack(key: String) -> [Double] {
    return Machine.stack.object(forKey: key) as? [Double] ?? [Double]()
  }
  
  static func getBalance(key: String) -> Double {
    return stack.object(forKey: balanceKey) as? Double ?? 0.0
  }
  
  static func insertCoin(coin: Coin) throws {
    var balance = getBalance(key: balanceKey)
    if coin != .Penny {
      balance += coin.rawValue
      var newStack = getStack(key: stackKey)
      newStack.append(coin.rawValue)
      newStack.sort(by: { $0 > $1})
      stack.set(newStack, forKey: stackKey)
      stack.set(balance, forKey: balanceKey)
    } else {
      throw VendingMachineError.invalidCoin
    }
  }
  
  static func updateBalance(value: [Double]) {
    Machine.stack.set(0.0, forKey: balanceKey)
    Machine.stack.set(value, forKey: stackKey)
  }
  
  static func makeChange(value: Double) throws -> [Double] {
    guard value > 0 else { return [] }
    var result: [Double] = []
    var valueCopy = value
    var stack = getStack(key: Machine.stackKey)
    
    for coin in stack {
      if valueCopy - coin >= 0 {
        result.append(coin)
        valueCopy -= coin
        stack.removeFirst()
      } else {
        break
      }
    }
    
    if valueCopy != 0 {
      throw VendingMachineError.insufficientFunds(valueNeeded: value)
    } else {
      updateBalance(value: stack)
    }
    return result
  }
  
  static func checkStock(product: String, products: [String: Int]) throws -> Bool{
    if let stock = products[product] {
      if stock > 0 {
        return true
      } else { throw VendingMachineError.outOfStock }
    } else {
      throw VendingMachineError.invalidSelection
    }
  }
  
  static func getCoins() throws{
    if var newTray: [String: Any] = stack.object(forKey: trayKey) as? [String: Any] {
      if var changeTray = newTray["Change"] as? [Double] {
        changeTray += try makeChange(value: stack.double(forKey: balanceKey))
        newTray["Change"] = changeTray
        stack.set(newTray, forKey: trayKey)
      }
    } else {
        let changeTray = try makeChange(value: stack.double(forKey: balanceKey))
        var newTray: [String: Any] = [:]
        newTray["Change"] = changeTray
        stack.set(newTray, forKey: trayKey)
    }
  }
  
  static func giveProduct(product: Product) throws -> Bool{
    if getBalance(key: Machine.balanceKey) >= product.rawValue {
      if let products: [String: Int] = Machine.stack.object(forKey: Machine.productsKey) as? [String: Int] {
        switch product {
          case .Coke:
            return try checkStock(product: "Coke", products: products)
          case .Chips:
            return try checkStock(product: "Chips", products: products)
          case .Candy:
            return try checkStock(product: "Candy", products: products)
        }
      } else {
        throw VendingMachineError.invalidSelection
      }
    } else {
      throw VendingMachineError.insufficientFunds(valueNeeded: product.rawValue)
    }
  }
  
}
