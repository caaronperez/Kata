//
//  Coin.swift
//  Kata
//

enum Coin: Double {
  case Penny = 0.01
  case Nickel = 0.05
  case Dimme = 0.1
  case Quarter = 0.25
}

enum Product: Double {
  case Coke = 1.0
  case Chips = 0.5
  case Candy = 0.65
}

enum VendingMachineError: Error {
  case invalidSelection
  case invalidCoin
  case insufficientFunds(valueNeeded: Double)
  case outOfStock
}
