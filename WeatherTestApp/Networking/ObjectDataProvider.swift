//
//  ObjectDataProvider.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 07.02.2022.
//

import Alamofire
import ObjectMapper

class ObjectDataProvider<T: Mappable>: DataProvider {
    
    // MARK: - Properties
    
    var object: T?
    var delegate: DataProviderDelegate?
    var request: URLRequestConvertible?
    
    
    // MARK: - Methods
    
    func loadData() {
        
        delegate?.willShowResponseLoading(self)
        
        // Погода берётся на 7 дней из-за ограничений платной подписки
        if let request = request {
            
            Alamofire.request(request).responseObject { [weak self] (response: DataResponse<T>) in

                guard let dataProvider = self else { return }

                if let result = response.result.value {

                    dataProvider.object = result
                    dataProvider.delegate?.willShowResponseSuccess(dataProvider)
                } else {

                    dataProvider.delegate?.willShowResponseError(dataProvider)
                }
            }
        }
    }
}
