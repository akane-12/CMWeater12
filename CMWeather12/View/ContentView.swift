//
//  ContentView.swift
//  CMWeather12
//
//  Created by cmStudent on 2023/01/13.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel(makeSessionType: MakeSession())
    @Environment(\.colorScheme) var colorScheme
    
    
    private var width = UIScreen.main.bounds.width
    private var height = UIScreen.main.bounds.height
    
//    struct Input {
//
//        let prefectureName: String
//        let cityName: String
//
//        let iconImage: UIImage
//        let weatherText: String
//
//        let tempText: String
//        let humidText: String
//        let popText: String
//    }
    
    var body: some View {
        
        VStack {
            Spacer()
            Group {
                HStack {
                    Spacer()
                    
                    VStack {
                        Image(uiImage: viewModel.iconImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width / 4)
                            .background(colorScheme == .dark ? Color.gray : Color.gray)
                            .cornerRadius(20)
                        
                        Text(viewModel.weatherText)
                            .font(.title3)
                            .padding()
                    }
                    
                    Spacer()
                    
                    VStack {
                        
                        Text(viewModel.prefectureName)
                            .font(.system(size: width / 8))
                        
                        Text(viewModel.cityName)
                            .font(.title)
                    }
                    
                    Spacer()
                }
                
                Divider()
                    .frame(height: 1)
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .padding()
                
                
                HStack {
                    Spacer()
                    Text("気温:  \(viewModel.tempText) ℃")
                        .font(.title)
                    
                    Spacer()
                    
                    Text("湿度:  \(viewModel.humidText) %")
                        .font(.title)
                    
                    Spacer()
                }
                .padding()
                
                Text("降水確率:  \(viewModel.popText) %")
                    .font(.title)
            }
            
            Spacer()
            Spacer()
            
            Picker(selection: $viewModel.selected, label: Text("県名")) {
                
                ForEach(0..<viewModel.prefectures.count, id: \.self) { index in
                    Text(viewModel.prefectures[index])
                }
                
            }.pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
            
            Button {
                viewModel.apply()
            } label: {
                Text("更新")
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(colorScheme == .dark ? Color.purple : Color.orange)
            }
            
            Spacer()
        }
        .alert(isPresented: $viewModel.isShowErrar) {
            Alert(title: Text("エラ-"), message: Text("情報を取得できませんでした。"))
        }
        .onAppear {
            viewModel.apply()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
