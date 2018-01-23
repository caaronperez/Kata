//
//  ViewController.swift
//  Kata


import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func sum(having coins: Currency) -> Double {
    var total: Double = 0
    
    for coin in coins {
      switch coins {
      case Currency.Penny: total += 0.01
      case Currency.Nickel: total += 0.05
      case Currency.Quarter: total += 0.25
      case Currency.Dimme: total += 0.10
      }
    }
    
    return total
  }
}

