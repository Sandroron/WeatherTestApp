//
//  CityWeatherLocalDataProvider.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 07.02.2022.
//

import Foundation

class CityWeatherLocalDataProvider: LocalDataProvider, DataProviderDelegate {
    
    // MARK: - Constants
    
    private let dataBaseManager = DataBaseManagerImplementation()
    
    
    // MARK: - Private properties
    
    private var city: City!
    private var dataProvider = CityWeatherDataProvider()
    
    
    // MARK: - Properties
    
    var delegate: LocalDataProviderDelegate?
    
    
    // MARK: - DataProviderDelegate
    
    // TODO: private
    func willShowResponseSuccess(_ dataProvider: DataProvider) {
        
        let cityWeather = CityWeatherModel()
        let name = city.name
        
        if // let location = city.location,
           let current = self.dataProvider.object?.current,
           let daily = self.dataProvider.object?.daily {
            
            cityWeather.name = name
//            cityWeather.longitude = Float(location.coordinate.longitude)
//            cityWeather.latitude = Float(location.coordinate.latitude)
            
            for dailyWeather in daily {
                
                let dailyWeatherModel = DailyWeatherModel()
                dailyWeatherModel.temp = Int(round(dailyWeather.temp?.average ?? 0))
                dailyWeatherModel.main = dailyWeather.weather?.first?.main ?? ""
                
                cityWeather.daily.append(dailyWeatherModel)
            }
            
            let currentWeatherModel = DailyWeatherModel()
            currentWeatherModel.temp = Int(round(current.temp ?? 0))
            currentWeatherModel.main = current.weather?.first?.main ?? ""
            
            cityWeather.current = currentWeatherModel
            
            dataBaseManager.save(cityWeather: cityWeather)
            
            delegate?.willShowResponseSuccess(self)
        } else if dataBaseManager.obtainCityWeather(in: city) != nil {
            
            delegate?.willShowResponseSuccess(self)
        } else {
            
            delegate?.willShowResponseError(self)
        }
    }

    func willShowResponseLoading(_ dataProvider: DataProvider) {
        
        delegate?.willShowResponseLoading(self)
    }

    func willShowResponseError(_ dataProvider: DataProvider) {
        
        if dataBaseManager.obtainCityWeather(in: city) == nil {
            
            delegate?.willShowResponseError(self)
        } else {
            
            delegate?.willShowResponseSuccess(self)
        }
    }
    
    
    // MARK: - Methods
    
    func obtainCityWeather(in city: City) -> CityWeatherModel? {
        
        return dataBaseManager.obtainCityWeather(in: city)
    }
    
    func setup(with city: City, delegate: LocalDataProviderDelegate) {
        
        self.city = city
        self.delegate = delegate
        
        dataProvider.setup(with: city, delegate: self)
    }
    
    func loadData() {
        
        dataProvider.loadData()
    }
}


