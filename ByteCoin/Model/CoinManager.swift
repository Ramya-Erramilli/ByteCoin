//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didRecieveCoinRate(_ coinManager:CoinManager,coinData:CoinData)
    func didFailWithError(error:Error)
}



struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "5B04AEB1-1036-4D65-A78A-4E87551EBCEC"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    mutating func getCoinPrice(for currency: String){
        var urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)&"
        urlString+=currency
        performRequest(urlString: urlString)
    }
    
    
    func performRequest(urlString:String){

        let url = URL(string: urlString)!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
             
            if let err=error{
                print(err.localizedDescription)
            }
            
            if let safeData = data{
                if let data = self.parseJson(safeData){
                    self.delegate?.didRecieveCoinRate(self, coinData: data)
                }
               
                
            }
        }
        
        task.resume()
  
    }
    
    func parseJson(_ coinData: Data)->CoinData?{
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            let id = decodedData.asset_id_base
            let currentRate = decodedData.rate
            let quote = decodedData.asset_id_quote
            let time = decodedData.time
            let coinData = CoinData(asset_id_base: id, rate: currentRate, time: time, asset_id_quote: quote)
            return coinData
        }catch{
//            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

extension Data
{
    func toString() -> String?
    {
        return String(data: self, encoding: .utf8)
    }
}
