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
  @IBOutlet weak var coinPicker: UIPickerView!
  
  
  let defaultMessage = "INSERT COIN"
  let secondMessage = "EXACT CHANGE ONLY"
  
 
  @IBAction func didPressInsertCoin(_ sender: Any) {
    coinPicker.isHidden = coinPicker.isHidden ? false : true
  }
  
  func checkChange() {
    do {
      _ = try Machine.makeChange(value: 1)
      mainScreen.text = defaultMessage
    } catch {
      mainScreen.text = secondMessage
    }
  }
  
  @IBAction func didPressGetBalance(_ sender: Any) {
    do {
      let changeTray = try Machine.makeChange(value: Machine.stack.double(forKey: Machine.balanceKey))
      displayOutput(elements: changeTray)
      checkChange()
    } catch {
      screenState(message: "UNABLE TO RETURN CHANGE")
    }
  }
  
  @objc func didTapOutput(sender:UITapGestureRecognizer) {
    output.text = "OUTPUT: "
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
    coinPicker.isHidden = true
    let tapAction = UITapGestureRecognizer(target: self, action: #selector(didTapOutput))
    output.isUserInteractionEnabled = true
    output.addGestureRecognizer(tapAction)
    checkChange()
    if Machine.stack.object(forKey: Machine.productsKey) as? [String: Int] == nil {
      Machine.stack.set(["Coke": 20, "Chips": 30, "Candy": 10], forKey: Machine.productsKey)
    }
    
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
      self.mainScreen.text = "BALANCE: \(Machine.getBalance(key: Machine.balanceKey))"
    }
  }
  
  func displayOutput(elements: [Double]) {
    for element in elements {
      if let e = output.text {
        output.text = "\(e) \(element)"
      }
    }
  }
  
  func didPressProduct(product: Product){

    do {
      if try Machine.giveProduct(product: product) {
          let newBalance = Machine.getBalance(key: Machine.balanceKey) - product.rawValue
          Machine.stack.set(newBalance, forKey: Machine.balanceKey)
          screenState(message: "THANKS")
          if let out = output.text {
            output.text = "\(out) \(product.stringValue)"
          }
      }
    } catch VendingMachineError.outOfStock {
        screenState(message: "OUT OF STOCK")
    } catch VendingMachineError.insufficientFunds(let value) {
        screenState(message: "INSUFFICIENT BALANCE. REQUIRED: \(value)")
    } catch VendingMachineError.invalidSelection {
        screenState(message: "INVALID SELECTION")
    } catch {
        screenState(message: "THERE WAS AN ERROR")
    }
  }
  
}

extension ViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return Coin.count.hashValue
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return Coin(rawValue: row)?.description
  }
  
}

extension ViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    coinPicker.isHidden = coinPicker.isHidden ? false : true
    do {
      let coin = Coin(rawValue: row)
      try Machine.insertCoin(coin: coin!)
      screenState(message: "INSERTED: \(coin!.value)")
    } catch VendingMachineError.invalidCoin {
      screenState(message: "INVALID COIN")
      if let out = output.text {
        output.text = "\(out) 0.1"
      }
    } catch {
      screenState(message: "THERE WAS AN ERROR")
    }
  }
}

