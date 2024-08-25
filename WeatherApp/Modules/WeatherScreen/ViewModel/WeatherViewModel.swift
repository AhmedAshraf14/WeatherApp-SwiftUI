//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Ahmed Ashraf on 25/08/2024.
//

import Foundation

class WeatherViewModel: ObservableObject{
    @Published var weatherResponse : WeatherResponse?
    @Published var isDaytime : Bool = true
    
    private let networkManager : NetworkManagerProtocol?
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func fetchWeatherData(){
        networkManager?.fetchData(completion: { [weak self] result in
            if let result = result{
                print(result)
                self?.weatherResponse = result
                self?.updateDaytimeStatus()
            }else {
                print("Error in viewModel fetching data")
            }
        })
    }
    
     func getDayName(from dateString: String) -> String {
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
    
    private func updateDaytimeStatus() {
            guard let currentTime = weatherResponse?.location.localtime else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            if let currentDate = dateFormatter.date(from: currentTime) {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: currentDate)
                
                isDaytime = (hour >= 5 && hour < 18)
            } else {
                isDaytime = true
            }
        }
}
