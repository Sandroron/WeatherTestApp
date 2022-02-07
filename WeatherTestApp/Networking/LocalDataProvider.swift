//
//  LocalDataProvider.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 07.02.2022.
//

import Foundation

class LocalDataProvider: NSObject {
    
    // Базовый класс
}

protocol LocalDataProviderDelegate {
    
    func willShowResponseSuccess(_ dataProvider: LocalDataProvider)
    func willShowResponseLoading(_ dataProvider: LocalDataProvider)
    func willShowResponseError(_ dataProvider: LocalDataProvider)
}
