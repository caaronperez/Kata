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
      let coinInserted = Coin.Dimme
      try Machine.insertCoin(coin: coinInserted)
      let lastCoin = Machine.getBalance(key: Machine.balanceKey).last
      XCTAssertEqual(lastCoin, coinInserted.rawValue)
    } //It accept coins and are appended to the default user
  
    func testRejectCoins() {
      let coinInserted = Coin.Dimme
      XCTAssertThrowsError(try Machine.insertCoin(coin: coinInserted)) { error in
        guard case VendingMachineError.invalidCoin = error else {
          return XCTFail()
        }
      }
      
    } //It doesn't accept pennys so it have to be appended to the change
  
    func testThrowChange() throws{
      let change = 2.0
      XCTAssertThrowsError(try Machine.makeChange(value: change)) { error in
        guard case VendingMachineError.insufficientFunds(let value) = error else {
          return XCTFail()
        }
        XCTAssertEqual(value, change)
      }
    } //Calculate the change with the minimum coins
  
    func testThrowCompleteChange() throws {
      //let changeRequired = Machine.checkBalance(key: Machine.balanceKey)
      let changeRequired = 0.0
      let change = try Machine.makeChange(value: changeRequired)
      let totalChange = change.reduce(0, {$0 + $1})
      XCTAssertEqual(totalChange, changeRequired)
    }
  
    func testCheckBalance() {
      let balance = Machine.checkBalance(key: Machine.balanceKey)
      let stack = Machine.checkBalance(key: Machine.stackKey)
      XCTAssert(balance != stack)
    } //Check the balance on the user default and sum all
  
    func testGetProduct() {
      
    } //Print the product
  
  
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
