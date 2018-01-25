//
//  KataTests.swift
//  KataTests
//
//  Created by MCS Devices on 1/22/18.
//  Copyright © 2018 MCS Devices. All rights reserved.
//

import XCTest
@testable import Kata

class KataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAceptCoins() throws {
      let coinInserted = Coin.Quarter
      let previousBalance = Machine.getBalance(key: Machine.balanceKey)
      try Machine.insertCoin(coin: coinInserted)
      let newBalance = Machine.getBalance(key: Machine.balanceKey)
      XCTAssertEqual(previousBalance, newBalance - coinInserted.value)
    } //It accept coins and are appended to the default user
  
    func testRejectCoins() {
      let coinInserted = Coin.Penny
      XCTAssertThrowsError(try Machine.insertCoin(coin: coinInserted)) { error in
        guard case VendingMachineError.invalidCoin = error else {
          return XCTFail()
        }
      }
    } //It doesn't accept pennys so it have to be appended to the change
  
    func testThrowIncompleteChange() throws{
      let change = 200000.0
      XCTAssertThrowsError(try Machine.makeChange(value: change)) { error in
        guard case VendingMachineError.insufficientFunds(let value) = error else {
          return XCTFail()
        }
        XCTAssertEqual(value, change)
      }
    } //Calculate the change with the minimum coins
  
    func testThrowCompleteChange() throws {
      //let changeRequired = Machine.checkBalance(key: Machine.balanceKey)
      let changeRequired = 0.25
      let change = try Machine.makeChange(value: changeRequired)
      let totalChange = change.reduce(0, {$0 + $1})
      XCTAssertEqual(totalChange, changeRequired)
    }
  
    func testCheckBalance() throws {
      let coin = Coin.Dimme
      try Machine.insertCoin(coin: coin)
      let balance = Machine.getBalance(key: Machine.balanceKey)
      XCTAssert(balance >= coin.value)
    } //Check the balance on the user default and sum all
  
    func testGetProduct() {
      do {
        try Machine.insertCoin(coin: .Quarter)
        try Machine.insertCoin(coin: .Quarter)
        if try Machine.giveProduct(product: .Chips) {
          XCTAssert(true, "Correct")
        }
      } catch VendingMachineError.insufficientFunds(let value) {
        XCTFail("Not enough balance for this product: \(value)")
      } catch VendingMachineError.outOfStock {
        XCTFail("Product out of stock")
      } catch VendingMachineError.invalidSelection {
        XCTFail("This product doesn't exist")
      } catch {
        XCTFail("Unknowed error")
      }
    }
  
    func testCheckStock() {
      Machine.stack.set(["Coke": 20, "Chips": 30, "Candy": 10], forKey: Machine.productsKey)
      if let products = Machine.stack.object(forKey: Machine.productsKey) as? [String: Int] {
        XCTAssert(try Machine.checkStock(product: "Coke", products: products))
      } else {
        XCTFail("No products")
      }
    }
  
    func testInvalidProduct() {
      if let products = Machine.stack.object(forKey: Machine.productsKey) as? [String: Int] {
        XCTAssertThrowsError(try Machine.checkStock(product: "Water", products: products)) { error in
          guard case VendingMachineError.invalidSelection = error else {
            return XCTFail()
          }
        }
      } else {
        XCTFail()
      }
    }
    
}
