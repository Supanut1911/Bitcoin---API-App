//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
import UIKit

protocol CoinManagerDelegate{
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
    
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    var rateValue: Double?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "9ADB2AC7-8712-48E9-BDFD-C761B9608D95"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR","THB"]

 
//    func getCoinPrice() -> String {
//        let rateString = String(format:"%.2f", rateValue!)
//    }
    
    func fetchCoin(coinName: String){
        let urlString = "\(baseURL)\(coinName)?&apikey=\(apiKey)"
        print(urlString)
        self.performRequest(with: urlString)
    }
    
    func performRequest(with urlstring: String) {
        if let url = URL(string: urlstring) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coindData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinModel.self, from: coindData)
            let rate = decodedData.rate
            
            let coin = CoinModel(rate: rate)
            return coin
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
   
}
