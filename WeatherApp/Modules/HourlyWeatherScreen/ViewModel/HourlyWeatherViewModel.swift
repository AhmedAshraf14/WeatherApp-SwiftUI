//
//  HourlyWeatherViewModel.swift
//  WeatherApp
//
//  Created by Ahmed Ashraf on 25/08/2024.
//

import Foundation

class HourlyWeatherViewModel: ObservableObject {
    @Published var hourlyForecast: [Hour]
    @Published var isDaytime: Bool

    init(hourlyForecast: [Hour], isDaytime: Bool) {
        self.hourlyForecast = hourlyForecast
        self.isDaytime = isDaytime
    }
    
    var filteredHourlyForecast: [Hour] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let currentDate = Date()
        guard let currentHourIndex = hourlyForecast.firstIndex(where: {
            if let date = dateFormatter.date(from: $0.time) {
                return Calendar.current.isDate(date, equalTo: currentDate, toGranularity: .hour)
            }
            return false
        }) else {
            return Array(hourlyForecast.prefix(5))
        }
        
        return Array(hourlyForecast[currentHourIndex..<min(currentHourIndex + 6, hourlyForecast.count)])
    }

    func formatTime(_ timeString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if let date = dateFormatter.date(from: timeString) {
            let calendar = Calendar.current
            let currentHour = calendar.component(.hour, from: Date())
            let forecastHour = calendar.component(.hour, from: date)
            
            if currentHour == forecastHour {
                return "Now"
            }
            dateFormatter.dateFormat = "h a"
            return dateFormatter.string(from: date)
        }
        return timeString
    }
}

