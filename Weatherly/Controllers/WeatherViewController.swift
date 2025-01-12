//
//  WeatherViewController.swift
//  Weatherly
//
//  Created by Rukhsar on 1/12/25.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    private var viewModel: WeatherViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = WeatherViewModel(weatherService: WeatherService())
        bindViewModel()
        viewModel.fetchWeather(for: "San Francisco")
    }
    
    private func bindViewModel() {
        viewModel.cityName.bind { [weak self] cityName in
            self?.cityNameLabel.text = cityName
        }
        
        viewModel.temperature.bind { [weak self] temperature in
            self?.temperatureLabel.text = temperature
        }
        
        viewModel.weatherDescription.bind { [weak self] description in
            self?.weatherDescriptionLabel.text = description
        }
        
        viewModel.weatherIcon.bind { [weak self] iconURL in
            guard let url = iconURL else { return }
            self?.loadWeatherIcon(from: url)
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
                self?.activityIndicatorView.isHidden = false
            } else {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicatorView.isHidden = true
            }
        }
        
        viewModel.error.bind { [weak self] errorMessage in
            if let message = errorMessage {
                self?.showError(message)
            }
        }
    }
    
    private func loadWeatherIcon(from url: String) {
        AF.request(url).responseData { response in
            if case .success(let data) = response.result {
                self.weatherIconImageView.image = UIImage(data: data)
            }
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        viewModel.fetchWeather(for: "San Francisco")
    }
    
    @IBAction func searchCityButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Search City", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter city name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Search", style: .default, handler: { [weak self] _ in
            if let city = alert.textFields?.first?.text, !city.isEmpty {
                self?.viewModel.fetchWeather(for: city)
            }
        }))
        
        present(alert, animated: true)
    }
}
