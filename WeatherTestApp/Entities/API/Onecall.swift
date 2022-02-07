//
//  Weather.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 06.02.2022.
//

import ObjectMapper

class Onecall: Mappable {
    
    // MARK: - Static constants
    
    static let f_daily = "daily"
    static let f_current = "current"
    
    
    // MARK: - Properties
    
    var daily: [Daily]?
    var current: Current?
    
    
    // MARK: - Mappable
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        daily <- map[Onecall.f_daily]
        current <- map[Onecall.f_current]
    }
}
