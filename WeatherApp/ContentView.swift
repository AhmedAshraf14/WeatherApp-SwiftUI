//
//  ContentView.swift
//  WeatherApp
//
//  Created by Ahmed Ashraf on 24/08/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel : WeatherViewModel
    var body: some View {
        ZStack{
            Image(viewModel.isDaytime ? "morningBackground" : "eveningBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Current weather, forecast list, and weather details views
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
            }
            if let url = URL(string: "https:" + (viewModel.weatherResponse?.current.condition.icon ?? "")) {
                AsyncImage(url: url)
                    .frame(width: 20,height: 20)
            }
        }
        .padding(.bottom,80)
    }
    
    private var forecastListView: some View {
        VStack(alignment: .leading) {
            Text("3-DAY FORECAST")
                .font(.title3)
                .bold()
                .padding(.top, 20)
            
            // Use a default empty array if forecastday is nil
            List(viewModel.weatherResponse?.forecast.forecastday ?? [], id: \.date) { day in
                NavigationLink(destination: HourlyWeatherView(hourlyData: day.hour)) {
                    HStack {
                        Text(getDayName(from: day.date))
                            .frame(maxWidth: 50)
                        Spacer()
                        if let url = URL(string: "https:" + (day.day.condition.icon)) {
                            AsyncImage(url: url)
                                .frame(width: 20, height: 20)
                        }
                        Spacer()
                        Text("\(day.day.mintempC, specifier: "%.1f") -")
                        Text("\(day.day.maxtempC, specifier: "%.1f")")
                    }
                    .background(Color.clear)
                    .padding(.vertical, 5)
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            //.scrollDisabled(true)
        }
        .padding(.horizontal)
    }

    private func getDayName(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                return "Today"
            } else {
                dateFormatter.dateFormat = "EEE"
                return dateFormatter.string(from: date)
            }
        }
        return dateString
    }

    
    var weatherDetailsView: some View {
        VStack {
            HStack {
                VStack{
                    Text("Visibility")
                        .font(.body)
                    Text("\(viewModel.weatherResponse?.current.visKM ?? 0 ,specifier: "%1.f") km")
                        .font(.largeTitle)
                }
                Spacer()
                VStack{
                    Text("Humidity")
                        .font(.body)
                    Text("\(viewModel.weatherResponse?.current.humidity ?? 0)%")
                        .font(.largeTitle)
                }
            }
            .padding()
            HStack {
                VStack{
                    Text("Visibility")
                        .font(.body)
                    Text("\(viewModel.weatherResponse?.current.feelslikeC ?? 0 ,specifier: "%1.f")°")
                        .font(.largeTitle)
                }
                Spacer()
                VStack{
                    Text("Pressure")
                        .font(.body)
                    Text("\(viewModel.weatherResponse?.current.pressureMB ?? 0 ,specifier: "%1.f")")
                        .font(.largeTitle)
                }
            }
            .padding()
        }
        .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationView{
        ContentView(viewModel: WeatherViewModel())
    }
}
