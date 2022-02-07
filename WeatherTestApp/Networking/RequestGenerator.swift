//
//  RequestGenerator.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 07.02.2022.
//

import Alamofire

enum RequestGenerator: URLRequestConvertible {
    
    
    // MARK: - Constants
    
    static let baseUrl = "https://api.openweathermap.org/data/2.5"
    static let apiKey = "71b702ca1dfd5c65aa322bd35e7a0ff5"
    static let units = "metric"
    
    
    // MARK: - Cases
    
    case onecall(lan: String, lon: String)
    
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        var routerCase = prepareRouterCase()
        
        let urlRequest = try RequestGenerator.prepareUrlRequest(method: routerCase.method, path: routerCase.path)
        RequestGenerator.prepareParameters(&routerCase.parameters)
        
        if let jsonObject = routerCase.jsonObject {
            
            let urlRequest = try URLEncoding(destination: .queryString).encode(urlRequest, with: routerCase.parameters)
            return try JSONEncoding.default.encode(urlRequest, withJSONObject: jsonObject)
        } else {
            
            return try URLEncoding.default.encode(urlRequest, with: routerCase.parameters)
        }
    }
    
    
    // MARK: - Methods
    
    func prepareRouterCase() -> (method: HTTPMethod, path: String, parameters: Parameters?, jsonObject: Any?) {
        
        let method: HTTPMethod = .get // var
        var path: String? = nil
        var parameters: Parameters? = nil
        let jsonObject: Any? = nil  // var
        
        switch self {
        
        case let .onecall(lan, lon):
            path = "/onecall"
            parameters = [
                "lat": lan,
                "lon": lon,
                "exclude": "minutely,hourly",
            ]
        }
            
        return (method: method, path: path!, parameters: parameters, jsonObject: jsonObject)
    }
    
    
    // MARK: - Static methods
    
    static func prepareParameters(_ parameters: inout Parameters?) {
        
        if parameters == nil {
            
            parameters = [
                "appid": RequestGenerator.apiKey,
                "units": RequestGenerator.units, // TODO: Брать из настроек приложения
                "lang": "ru", // TODO: Брать из настроек системы
            ]
            
        } else {
            
            parameters!["appid"] = RequestGenerator.apiKey
            parameters!["units"] = RequestGenerator.units // TODO: Брать из настроек приложения
            parameters!["lang"] = "ru" // TODO: Брать из настроек системы
        }
    }
    
    static func prepareUrlRequest(method: HTTPMethod, path: String) throws -> URLRequest {
        
        let baseUrl = try RequestGenerator.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: baseUrl.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}

