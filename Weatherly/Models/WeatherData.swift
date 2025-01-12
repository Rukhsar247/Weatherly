//
//  WeatherData.swift
//  Weatherly
//
//  Created by Rukhsar on 1/12/25.
//

import Foundation

struct Weather {
    let city: String
    let temperature: Double
    let description: String
    let iconURL: String
}

struct WeatherResponse: Decodable {
    let main: Main
    let weather: [WeatherDetail]
    let name: String

    func toWeather() -> Weather {
        return Weather(
            city: name,
            temperature: main.temp,
            description: weather.first?.description ?? "",
            iconURL: "https://openweathermap.org/img/wn/\(weather.first?.icon ?? "")@2x.png"
        )
    }
}

struct Main: Decodable {
    let temp: Double
}

struct WeatherDetail: Decodable {
    let description: String
    let icon: String
}

// MARK: - Observable
class Observable<T> {
    private var listener: ((T) -> Void)?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(_ listener: @escaping (T) -> Void) {
        self.listener = listener
        listener(value)
    }
}
