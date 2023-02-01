//
//  MakeSession.swift
//  CMWeather12
//
//  Created by cmStudent on 2023/01/13.
//

import Foundation
import Combine

protocol MakeSessionType {
    func request<Request>(request: Request)
    -> AnyPublisher<Request.Responce, APIError>
    where Request: MakeRequestType
}

final class MakeSession: MakeSessionType {
    
    private let baseURLStr = "https://api.openweathermap.org/"
    
    // requestメソッド
    func request<Request>(request: Request)
    -> AnyPublisher<Request.Responce, APIError>
    where Request: MakeRequestType {
        
        // bace, pathからURLをつくる
        guard let pathURL = URL(string: request.path,
                                relativeTo: URL(string: baseURLStr)) else {
            print("E: MakeSession/1")
            return Fail(error: APIError.urlError).eraseToAnyPublisher()
        }
        
        // クエリ乗せ
        var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = request.queryItems
        
        // リクエストつくる
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // デコーダー
        let decoder = JSONDecoder()
        //スネークケースをキャメルケースに
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Publisher
        return URLSession.shared.dataTaskPublisher(for: request)
            .map {data, urlResponse in data }
            .mapError { _ in APIError.responseError}
            .decode(type: Request.Responce.self, decoder: decoder)
            .mapError { _ in APIError.jsonError}
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
