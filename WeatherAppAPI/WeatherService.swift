//
//  WeatherService.swift
//  WeatherAppAPI
//
//  Created by Matheus Silva on 16/06/25.
//

import Foundation

class WeatherService {
    
    func fetchWeather(completion: @escaping (Result<[Forecast], Error>) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=-23.5489&lon=-46.6388&units=metric&appid=API-KEY") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0)))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }

            do {
                let weatherResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(.success(weatherResponse.list))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

struct ForecastResponse: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [Forecast]
}

struct Forecast: Decodable {
    let dt: Int
    let main: MainInfo
    let weather: [Weather]
    let clouds: Clouds
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, visibility, pop, rain
        case dtTxt = "dt_txt"
    }
}

struct MainInfo: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int
    let grndLevel: Int
    let humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case tempKf = "temp_kf"
    }
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Clouds: Decodable {
    let all: Int
}

struct Rain: Decodable {
    let threeHour: Double
    
    enum CodingKeys: String, CodingKey {
        case threeHour = "3h"
    }
}
