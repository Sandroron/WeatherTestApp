//
//  DataProvider.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 06.02.2022.
//

import Alamofire
import ObjectMapper

class DataProvider: NSObject {
    
    // Базовый класс
}

protocol DataProviderDelegate {
    
    func willShowResponseSuccess(_ dataProvider: DataProvider)
    func willShowResponseLoading(_ dataProvider: DataProvider)
    func willShowResponseError(_ dataProvider: DataProvider)
}
