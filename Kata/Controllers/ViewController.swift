//
//  ViewController.swift
//  Kata


import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var cokeButton: UIButton!
  @IBOutlet weak var chipsButton: UIButton!
  @IBOutlet weak var candyButton: UIButton!
  @IBOutlet weak var mainScreen: UILabel!
  @IBOutlet weak var cokeImage: UIImageView!
  @IBOutlet weak var chipsImage: UIImageView!
  @IBOutlet weak var candyImage: UIImageView!
  @IBOutlet weak var insertCoinButton: UIButton!
  @IBOutlet weak var getBalanceButton: UIButton!
 
  
  let defaultMessage = "Welcome"
  
  @IBAction func returnCoins(_ sender: Any) {
    
  }
  
  @IBAction func didPressGetBalance(_ sender: Any) {
  }
  
  @IBAction func didPressChips(_ sender: Any) {
    didPressProduct(product: .Chips)
  }
  
  @IBAction func didPressCandy(_ sender: Any) {
    didPressProduct(product: .Candy)
  }
  
  @IBAction func didPressCoke(_ sender: Any) {
    didPressProduct(product: .Coke)
  }
  
  @IBOutlet weak var output: UILabel!
  let balance: [Double] = []
  
  func initElements() {
    chipsImage.image = #imageLiteral(resourceName: "chips")
    cokeImage.image = #imageLiteral(resourceName: "coke")
    candyImage.image = #imageLiteral(resourceName: "candy")
    mainScreen.text = self.defaultMessage
    cokeButton.setTitle("Coke", for: .normal)
    chipsButton.setTitle("Chips", for: .normal)
    candyButton.setTitle("Candy", for: .normal)
    insertCoinButton.setTitle("Insert coin", for: .normal)
    getBalanceButton.setTitle("Get balance", for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initElements()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func screenState(message: String) {
    mainScreen.text = message
    let when = DispatchTime.now() + 2
    DispatchQueue.main.asyncAfter(deadline: when) {
      self.mainScreen.text = "Balance: \(Machine.getBalance(key: Machine.balanceKey))"
    }
  }
  
  func didPressProduct(product: Product){
    
    func setTray(tray: [String: Any]) {
      var copyTray = tray
      switch product {
      case .Candy:
        copyTray["Candy"] = 1
      case .Chips:
        copyTray["Chips"] = 1
      case .Coke:
        copyTray["Coke"] = 1
      }
      Machine.stack.set(copyTray, forKey: Machine.trayKey)
      output.text = "Current output: \(Machine.stack.object(forKey: Machine.trayKey) as! [String: Any])"
    }
    
    func displayOutput(elements: [String: Any]) {
      output.text = "Output: "
      for element in elements {
        output.text = "\(output.text) \(element)"
      }
    }
    
    do {
        if try Machine.giveProduct(product: product) {
          let newBalance = Machine.getBalance(key: Machine.balanceKey) - Product.Coke.rawValue
          Machine.stack.set(newBalance, forKey: Machine.balanceKey)
          if let newTray: [String: Any] = Machine.stack.object(forKey: Machine.trayKey) as? [String: Any] {
            setTray(tray: newTray)
          } else {
            setTray(tray: [:])
          }
      }
    } catch VendingMachineError.outOfStock {
        screenState(message: "Out of stock")
    } catch VendingMachineError.insufficientFunds(let value) {
        screenState(message: "Insufficient balance. Required: \(value)")
    } catch VendingMachineError.invalidSelection {
        screenState(message: "Invalid selection")
    } catch {
        screenState(message: "There was an error")
    }
  }
  
}

