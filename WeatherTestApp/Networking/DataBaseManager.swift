//
//  DataBaseManager.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 07.02.2022.
//

import RealmSwift

class DataBaseManagerImplementation: DataBaseManager {
    
    // MARK: - Properties
    
    fileprivate lazy var mainRealm = try! Realm(configuration: .defaultConfiguration)
    
    
    // MARK: - Methods
    
    func save(cityWeather: CityWeatherModel) {
        
        try! mainRealm.write {
            
            mainRealm.add(cityWeather)
        }
    }
    
    func remove(_ object: Object) {
        
        try! mainRealm.write {
            
            mainRealm.delete(object)
        }
    }
    
    func obtainCityWeather(in city: City) -> CityWeatherModel? {
        
//        let models = mainRealm.objects(CityWeatherModel.self)
        
        return mainRealm.object(ofType: CityWeatherModel.self, forPrimaryKey: city.name)
    }
}

protocol DataBaseManager {
    
    func save(cityWeather: CityWeatherModel)
    func remove(_ object: Object)
    func obtainCityWeather(in city: City) -> CityWeatherModel?
}

