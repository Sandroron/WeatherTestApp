//
//  CityWeatherDataProvider.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 07.02.2022.
//

import Alamofire
import ObjectMapper

class CityWeatherDataProvider: ObjectDataProvider<Onecall> {
    
    
    // MARK: - Methods
    
    func setup(with city: City?, delegate: DataProviderDelegate) {
        
        self.delegate = delegate
        
        if let lan = city?.location?.coordinate.latitude,
           let lon = city?.location?.coordinate.longitude {
            
            request = RequestGenerator.onecall(lan: "\(lan)", lon: "\(lon)")
        }
    }
}
