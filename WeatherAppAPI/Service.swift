//
//  Service.swift
//  WeatherAppAPI
//
//  Created by Matheus Silva on 16/06/25.
//

import Foundation

struct City {
    let lat: Double
    let lon: Double
    let name: String
}

class Service {
    
    private let baseURL: String = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey: String = ""
    private let session = URLSession.shared
    
    func fetchData(city: City, completion: @escaping (WeatherResponse?) -> Void) {
        let urlString = "\(baseURL)?lat=\(city.lat)&lon=\(city.lon)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(weatherResponse)
            } catch {
                print("Erro ao decodificar: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}

    struct WeatherResponse: Decodable {
        let coord: Coord
        let base: String
        let main: Main
        let visibility: Int
        let wind: Wind
        let dt: Int
        let timezone: Int
        let id: Int
        let name: String
        let cod: Int
    }

    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }

    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
        let sea_level: Int?
        let grnd_level: Int?
    }

    struct Wind: Decodable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
