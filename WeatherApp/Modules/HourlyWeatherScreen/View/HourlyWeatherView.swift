//
//  HourlyWeatherView.swift
//  WeatherApp
//
//  Created by Ahmed Ashraf on 25/08/2024.
//

import SwiftUI

import SwiftUI

struct HourlyWeatherView: View {
    @ObservedObject var viewModel: HourlyWeatherViewModel

    var body: some View {
        ZStack {
            Image(viewModel.isDaytime ? "morningBackground" : "eveningBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            List(viewModel.filteredHourlyForecast, id: \.time) { hour in
                HStack {
                    Text(viewModel.formatTime(hour.time))
                        .bold()
                        .frame(maxWidth: 50)
                    Spacer()
                    if let iconURL = URL(string: "https:" + hour.condition.icon) {
                        AsyncImage(url: iconURL)
                        {
                            phase in
                            if let image = phase.image{
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 30)
                            }
                        }
                    }
                    Spacer()
                    Text("\(hour.tempC, specifier: "%.1f")°")
                        .bold()
                }
                .listRowBackground(Color.clear)
            }
            .foregroundColor(viewModel.isDaytime ? .black : .white)
            .padding(EdgeInsets(top: 30, leading: 50, bottom: 0, trailing: 50))
            .listStyle(PlainListStyle())
            .background(Color.clear)
        }
    }
}








//#Preview {
//    HourlyWeatherView(viewModel: <#T##HourlyWeatherViewModel#>)
//}

