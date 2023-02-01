//
//  ViewModel.swift
//  CMWeather12
//
//  Created by cmStudent on 2023/01/13.
//

import SwiftUI
import Combine

final class ViewModel: ObservableObject {
    
    // 表示用変数
    @Published var prefectureName: String = ""
    @Published var cityName: String = ""
    @Published var iconImage: UIImage = UIImage(named: "weather_icon")!
    @Published var weatherText: String = ""
    
    @Published var tempText: String = ""
    @Published var humidText: String = ""
    @Published var popText: String = ""
    
    // Pickerの選択
    @Published var selected: Int = 5
    
    // 都市名
    let citys = ["Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa"]
    let prefectures = ["茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県"]
    
    // エラーアラート
    @Published var isShowErrar = false
    
    
    private let makeSession: MakeSessionType
    
    private let subject = PassthroughSubject<String, Never>()
    private let errorSubject = PassthroughSubject<APIError, Never>()
    
    private var cancellable = Set<AnyCancellable>()
    
    
    init(makeSessionType: MakeSessionType) {
        self.makeSession = makeSessionType
        bind()
    }
    
    private func bind() {
        
        subject
            .flatMap{ city in
                self.makeSession.request(request: MakeRequest(city: city))
            }
            .catch { error -> Empty<ForecastItem, Never> in
                self.errorSubject.send(error)
                return Empty()
            }
            .sink{ item in
                self.convertInput(item: item)
            }.store(in: &cancellable)
        
        
        errorSubject
            .sink { error in
                self.isShowErrar = true
                print("E: viewModel/1 \(error) : \(error.localizedDescription)")
                self.isShowErrar = true
            }.store(in: &cancellable)
        
        print("C: bind")
        
    }
    
    private func convertInput(item: ForecastItem) {
        
        // アイコン画像
        let iconURL = URL(string: "http://openweathermap.org/img/wn/" + item.list[0].weather[0].icon + "@2x.png")
        print("icon: \(item.list[0].weather[0].icon)")
        let icon: UIImage?
        do {
            let data = try Data(contentsOf: iconURL!)
            icon = UIImage(data: data)
        } catch {
            print("iconError")
            icon = UIImage(named: "weather_icon")
        }
        
        prefectureName = prefectures[selected]
        cityName = item.city.name
        iconImage = icon!
        weatherText = item.list[0].weather[0].description
        tempText = String(item.list[0].main.temp)
        humidText = String(item.list[0].main.humidity)
        popText = String(item.list[0].pop)
        
        print("Date: \(item.list[0].dtTxt) UTC")
        
        print("C: comvert")
        
    }
    
    func apply() {
        
        subject.send(citys[selected])
        print("C: apply")
    }
    
    
}
