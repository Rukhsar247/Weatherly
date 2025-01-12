//
//  WeatherViewModel.swift
//  Weatherly
//
//  Created by Rukhsar on 1/12/25.
//

import Foundation

class WeatherViewModel {
    
    private let weatherService: WeatherServiceProtocol
    
    var cityName: Observable<String?> = Observable(nil)
    var temperature: Observable<String?> = Observable(nil)
    var weatherDescription: Observable<String?> = Observable(nil)
    var weatherIcon: Observable<String?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    var error: Observable<String?> = Observable(nil)
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func fetchWeather(for city: String) {
        
        isLoading.value = true
        error.value = nil
        
        weatherService.fetchWeather(for: city) { [weak self] result in
            guard let self = self else { return }
            self.isLoading.value = false
            
            switch result {
            case .success(let weather):
                self.cityName.value = weather.city
                self.temperature.value = "\(Int(weather.temperature))°C"
                self.weatherDescription.value = weather.description.capitalized
                self.weatherIcon.value = weather.iconURL
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
