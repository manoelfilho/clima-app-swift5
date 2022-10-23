//
//  WeatherData.swift
//  Clima
//
//  Created by Manoel Filho on 25/08/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//Codable permite a combinacao de dois protocolos: Encodable e Decodable para parses JSON

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}
