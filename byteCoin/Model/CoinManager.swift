//
//  CoinManager.swift
//  byteCoin
//
//  Created by Daniil Kulikovskiy on 25.05.2023.
//

import Foundation
import UIKit

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didError(error: Error)
}


struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "C0FB7158-D135-4FF7-A1ED-E2C1E04E5E2A"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL) + \(currency)?apikey=\(apiKey)"
        print(urlString)
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let _: Void = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJson(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }.resume()
        }
    }
    
    func parseJson(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch {
            delegate?.didError(error: error)
            return nil
        }
    }
}

