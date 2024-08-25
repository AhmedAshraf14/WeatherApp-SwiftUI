//
//  Weather.swift
//  WeatherApp
//
//  Created by Ahmed Ashraf on 25/08/2024.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let localtime: String
}

// MARK: - Current
struct Current: Codable {
    let tempC: Double
    let condition: Condition
    let feelslikeC: Double
    let humidity: Int
    let visKM: Double
    let pressureMB: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case feelslikeC = "feelslike_c"
        case humidity
        case visKM = "vis_km"
        case pressureMB = "pressure_mb"
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text: String
    let icon: String
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let date: String
    let day: Day
    let hour: [Hour]  // Add this line to include hourly data

    enum CodingKeys: String, CodingKey {
        case date
        case day
        case hour
    }
}

// MARK: - Day
struct Day: Codable {
    let maxtempC: Double
    let mintempC: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case condition
    }
}

// MARK: - Hour
struct Hour: Codable, Identifiable {
    let id = UUID()
    let time: String
    let tempC: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case condition
    }
}
