//
//  Daily.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 06.02.2022.
//

import ObjectMapper

class Daily: Mappable {
    
    // MARK: - Static constants
    
    static let f_temp = "temp"
    static let f_weather = "weather"
    
    
    // MARK: - Properties
    
    var temp: Temp?
    var weather: [Weather]?
    
    
    // MARK: - Mappable
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        temp <- map[Daily.f_temp]
        weather <- map[Daily.f_weather]
    }
}
