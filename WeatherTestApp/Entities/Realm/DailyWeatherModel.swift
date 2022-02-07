//
//  DailyWeatherModel.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 07.02.2022.
//

import RealmSwift

@objcMembers
class DailyWeatherModel: Object {
    
    dynamic var temp = Int()
    dynamic var main = String()
}
