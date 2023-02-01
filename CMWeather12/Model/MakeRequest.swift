//
//  MakeRequest.swift
//  CMWeather12
//
//  Created by cmStudent on 2023/01/13.
//

import Foundation

protocol MakeRequestType {
    
    associatedtype Responce: Decodable
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

struct MakeRequest: MakeRequestType {
    
    typealias Responce = ForecastItem
    
    // Tokyoとか
    private let city: String

    // TODO: API KEY
    private let apiKey = ""
    
    let path = "/data/2.5/forecast"
    var queryItems: [URLQueryItem]?
    
    init(city: String) {
        self.city = city
        self.queryItems = [URLQueryItem.init(name: "q", value: city),
                           URLQueryItem.init(name: "appid", value: apiKey),
                           URLQueryItem.init(name: "units", value: "metric"),
                           URLQueryItem.init(name: "lang", value: "ja")]
        
    }
}
   
