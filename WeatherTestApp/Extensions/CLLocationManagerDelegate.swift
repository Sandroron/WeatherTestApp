//
//  CLLocationManagerDelegate.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 06.02.2022.
//

import CoreLocation
import UIKit

extension CLLocationManagerDelegate where Self: UIViewController {
    
    // MARK: - Methods
    
    func showLocationError() {
        
        let alert = UIAlertController(title: "Ошибка!", message: "Доступ к GPS ограничен. Чтобы использовать отслеживание, включите GPS в приложении «Настройки» в разделе «Конфиденциальность», «Службы геолокации».", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Перейти в Настройки", style: .default, handler: { (alert: UIAlertAction!) in

            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))

        present(alert, animated: true)
    }
    
    func isLocationAuthorized() -> Bool {
        
        let status = CLLocationManager.authorizationStatus()
        
        if (status == .authorizedAlways || status == .authorizedWhenInUse),
           CLLocationManager.locationServicesEnabled() {
            
            return true
        } else {
            
            return false
        }
    }
    
    func needUpdateLocation(_ location: CLLocation?) -> Bool {
        
        if location == nil,
           isLocationAuthorized() {
            
            return true
        } else {
            
            return false
        }
    }
    
    func updateLocationIfNeeded(in locationManager: CLLocationManager, for location: CLLocation?) {
        
        if needUpdateLocation(location) {
            
            locationManager.requestLocation()
        }
    }
}
