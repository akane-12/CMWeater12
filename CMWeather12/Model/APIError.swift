//
//  APIError.swift
//  CMWeather12
//
//  Created by cmStudent on 2023/01/13.
//

import Foundation

enum APIError: Error {
    case urlError
    case responseError
    case jsonError
}
