//
//  ForecastItem.swift
//  CMWeather12
//
//  Created by cmStudent on 2023/01/13.
//

import Foundation

struct ForecastItem: Decodable {
    
    let list: [List]
    struct List: Decodable {
        
        let main: Main
        struct Main: Decodable {
            let temp: Double
            let humidity: Int
        }
        
        let weather: [Weather]
        struct Weather: Decodable {
            let description: String
            let icon: String
        }
        
        let pop: Double
        
        let dtTxt: String
    }
    
    let city: City
    struct City: Decodable {
        let name: String
    }
}
