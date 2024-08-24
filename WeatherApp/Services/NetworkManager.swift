//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Ahmed Ashraf on 25/08/2024.
//

import Foundation

protocol NetworkManagerProtocol{
    func fetchData(longtiude:Double, latitude:Double ,completion: @escaping ((WeatherResponse)->Void))
}

class NetworkManager:NetworkManagerProtocol{
    func fetchData(longtiude: Double, latitude: Double, completion: @escaping ((WeatherResponse) -> Void)) {
        let apikey = "f376b9d44c5942ba8f2184822230604"
        let urlString = "http://api.weatherapi.com/v1/forecast.json?key=\(apikey)&q=\(longtiude),\(latitude)&days=3&aqi=no&alerts=no"
        
        guard let url = URL(string: urlString) else {print("error in url") ; return}
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let error = error else {return}
            if let data = data{
                do{
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async{
                        completion(weatherResponse)
                    }
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
}
