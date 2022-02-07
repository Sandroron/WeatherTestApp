//
//  Weather.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 06.02.2022.
//

import ObjectMapper

class Weather: Mappable {
    
    // MARK: - Static constants
    
    static let f_description = "description"
    static let f_main = "main"
    
    
    // MARK: - Properties
    
    var description: String?
    var main: String?
    
    
    // MARK: - Mappable
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        description <- map[Weather.f_description]
        main <- map[Weather.f_main]
    }
}
