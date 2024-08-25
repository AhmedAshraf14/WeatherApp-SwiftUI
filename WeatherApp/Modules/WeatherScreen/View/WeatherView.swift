//
//  ContentView.swift
//  WeatherApp
//
//  Created by Ahmed Ashraf on 24/08/2024.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel : WeatherViewModel
    var body: some View {
        ZStack{
            Image(viewModel.isDaytime ? "morningBackground" : "eveningBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                currentWeatherView
                Spacer()
                forecastListView
                Spacer()
                weatherDetailsView
            }
            .foregroundColor(viewModel.isDaytime ? .black : .white)
            .padding()
        }
        .onAppear{
            viewModel.fetchWeatherData()
        }
    }
    
    var currentWeatherView: some View {
        VStack {
            Text(viewModel.weatherResponse?.location.name ?? "Loading...")
                .font(.largeTitle)
                .fontWeight(.medium)

            Text("\(viewModel.weatherResponse?.current.tempC ?? 0, specifier: "%.1f")°")
                .font(.title)
                .fontWeight(.medium)
            
            Text(viewModel.weatherResponse?.current.condition.text ?? "")
                .font(.title)
                .fontWeight(.medium)
            
            HStack {
                Text("H: \(viewModel.weatherResponse?.forecast.forecastday.first?.day.maxtempC ?? 0, specifier: "%.1f")°")
                Text("L: \(viewModel.weatherResponse?.forecast.forecastday.first?.day.mintempC ?? 0, specifier: "%.1f")°")
            }.font(.title3)
            if let url = URL(string: "https:" + (viewModel.weatherResponse?.current.condition.icon ?? "")) {
                AsyncImage(url: url)
                { phase in
                   if let image = phase.image {
                       image
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130, height: 130)
                           .offset(y: -40)
                   } else if phase.error != nil {
                       Text("Failed to load image")
                   } else {
                       ProgressView()
                   }
               }
            }
        }
        .padding(.top,25)
    }
    
    private var forecastListView: some View {
        VStack(alignment: .leading) {
            Text("3-DAY FORECAST")
                .font(.title3)
                .bold()
        
            List(viewModel.weatherResponse?.forecast.forecastday ?? []) { day in
                NavigationLink(destination: HourlyWeatherView(viewModel: HourlyWeatherViewModel(hourlyForecast: day.hour, isDaytime: viewModel.isDaytime))) {
                    HStack {
                        Text(viewModel.getDayName(from: day.date))
                            .frame(maxWidth: 50)
                            .font(.body)
                            .bold()
                        Spacer()
                        if let url = URL(string: "https:" + (day.day.condition.icon)) {
                            AsyncImage(url: url){
                                phase in
                                if let image = phase.image{
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 10)
                                }
                            }
                        }
                        Spacer()
                        Text("\(day.day.mintempC, specifier: "%.1f")° - \(day.day.maxtempC, specifier: "%.1f")°")
                            .font(.body)
                            .bold()
                    }
                    .padding(.vertical, 5)
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            //.scrollDisabled(true)
        }
        .offset(y: -40)
        .padding(.horizontal)
    }

    
    var weatherDetailsView: some View {
        VStack {
            HStack {
                VStack{
                    Text("Visibility".uppercased())
                        .font(.subheadline)
                    Text("\(viewModel.weatherResponse?.current.visKM ?? 0 ,specifier: "%1.f") km")
                        .font(.largeTitle)
                        .padding(.top,5)
                }
                Spacer()
                VStack{
                    Text("Humidity".uppercased())
                        .font(.subheadline)
                    Text("\(viewModel.weatherResponse?.current.humidity ?? 0)%")
                        .font(.largeTitle)
                        .padding(.top,5)
                }
            }
            .padding()
            HStack {
                VStack{
                    Text("Visibility".uppercased())
                        .font(.subheadline)
                    Text("\(viewModel.weatherResponse?.current.feelslikeC ?? 0 ,specifier: "%1.f")°")
                        .font(.largeTitle)
                        .padding(.top,5)
                }
                Spacer()
                VStack{
                    Text("Pressure".uppercased())
                        .font(.subheadline)
                    Text("\(viewModel.weatherResponse?.current.pressureMB ?? 0 ,specifier: "%1.f")")
                        .font(.largeTitle)
                        .padding(.top,5)
                }
            }
            .padding()
        }
        .padding(.horizontal,50)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationView{
        WeatherView(viewModel: WeatherViewModel())
    }
}
