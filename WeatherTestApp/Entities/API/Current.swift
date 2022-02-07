//
//  Current.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 06.02.2022.
//

import ObjectMapper

class Current: Mappable {
    
    // MARK: - Static constants
    
    static let f_temp = "temp"
    static let f_weather = "weather"
    
    
    // MARK: - Properties
    
    var temp: Float?
    var weather: [Weather]?
    
    
    // MARK: - Mappable
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        temp <- map[Current.f_temp]
        weather <- map[Current.f_weather]
    }
}
