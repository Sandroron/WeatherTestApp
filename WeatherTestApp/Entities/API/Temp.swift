//
//  Temp.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 06.02.2022.
//

import ObjectMapper

class Temp: Mappable {
    
    // MARK: - Static constants
    
    static let f_min = "min"
    static let f_max = "max"
    
    
    // MARK: - Properties
    
    var min: Float?
    var max: Float?
    
    var average: Float? {
        
        get {
            
            guard let min = min, let max = max else { return nil }
            
            return (min + max) / 2
        }
    }
    
    
    // MARK: - Mappable
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        min <- map[Temp.f_min]
        max <- map[Temp.f_max]
    }
}
