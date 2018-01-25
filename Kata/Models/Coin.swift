//
//  Coin.swift
//  Kata
//

enum Coin: Int {
  case Penny = 0
  case Nickel = 1
  case Dimme = 2
  case Quarter = 3
  
  var value: Double {
    switch self {
    case .Penny: return 0.01
    case .Nickel: return 0.05
    case .Dimme: return 0.1
    case .Quarter: return 0.25
    }
  }
  
  var description: String {
    switch self {
      case .Penny: return "Penny"
      case .Nickel   : return "Nickel"
      case .Dimme  : return "Dimme"
      case .Quarter : return "Quarter"
    }
  }
 
  static var count: Int { return Coin.Quarter.hashValue + 1 }
}

enum Product: Double {
  case Coke = 1.0
  case Chips = 0.5
  case Candy = 0.65
  
  var stringValue: String {
    switch self {
    case .Coke: return "Coke"
    case .Chips   : return "Chips"
    case .Candy  : return "Candy"
    }
  }
}

enum VendingMachineError: Error {
  case invalidSelection
  case invalidCoin
  case insufficientFunds(valueNeeded: Double)
  case outOfStock
}
