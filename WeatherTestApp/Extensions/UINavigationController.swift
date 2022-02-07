//
//  UINavigationController.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 06.02.2022.
//

import UIKit

extension UINavigationController {
    
    
    // MARK: - Methods
    
    func openWeather(inCity city: City) {
        
        pushViewController(CityWeatherViewController().configure(with: city), animated: true)
    }
}
