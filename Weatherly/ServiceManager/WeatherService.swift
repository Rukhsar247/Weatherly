//
//  WeatherService.swift
//  Weatherly
//
//  Created by Rukhsar on 1/12/25.
//

import Foundation
import Alamofire

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void)
}

class WeatherService: WeatherServiceProtocol {

    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        let parameters: [String: String] = [
            "q": city,
            "appid": Constants.apiKey,
            "units": "metric"
        ]

        AF.request(Constants.weatherURL, parameters: parameters).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let weatherResponse):
                completion(.success(weatherResponse.toWeather()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
