//
//  CoinData.swift
//  ByteCoin
//
//  Created by Ramya Seshagiri on 29/05/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData:Decodable {
    let asset_id_base:String
    let rate:Double
    let time:String
    let asset_id_quote:String
    
}
