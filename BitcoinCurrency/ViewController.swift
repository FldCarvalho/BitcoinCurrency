//
//  ViewController.swift
//  BitcoinCurrency
//
//  Created by user192816 on 5/18/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var mainPickerView: UIPickerView!
    
    @IBOutlet weak var bitcoinValue: UILabel!
    
    let publicKey = "ZWVhMzIxYmIwMGQzNDNkZWI2MGYxZDU2MTNhNDgxOTQ"
    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"
    let curruncies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(url: baseUrl)
        mainPickerView.delegate = self
        mainPickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
              return 1
        }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return curruncies.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return curruncies[row]
         }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
        fetchData(url: url)
    }
    
    func fetchData(url: String){
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(publicKey, forHTTPHeaderField: "x-ba-key")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                //let data = String(data: data, encoding: .utf8)
                self.parseJSON(json: data) 
            }else {
                print(error!)
            }
        }
        task.resume()
    }
    func parseJSON(json: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                print(json)
                if let askValue = json["ask"] as? NSNumber {
                    print(askValue)
                    var valueFormatter: NumberFormatter {
                            let formatter = NumberFormatter()
                            formatter.numberStyle = .decimal
                            formatter.maximumFractionDigits = 2
                            formatter.decimalSeparator = ","
                            formatter.groupingSeparator = "."
                            return formatter
                    }
                    DispatchQueue.main.async {
                        
                        self.bitcoinValue.text = valueFormatter.string(from: askValue)
                    }
                    print("success")
                } else {
                        print("error")
                    }
            }
        } catch {
            
            print("error parsing json: \(error)")
        }
    }
        
}

