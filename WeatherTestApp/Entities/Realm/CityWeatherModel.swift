//
//  CityWeatherModel.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 07.02.2022.
//

import CoreLocation
import RealmSwift

@objcMembers
class CityWeatherModel: Object {
    
    dynamic var name = String()
//    dynamic var latitude = Float()
//    dynamic var longitude = Float()
    dynamic var current: DailyWeatherModel?
    dynamic var daily = List<DailyWeatherModel>()
    
    override class func primaryKey() -> String? {
        
        // TODO: Заменить на ID
        return #keyPath(name)
    }
}
