//
//  HomeViewController.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 05.02.2022.
//

import CoreLocation
import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
                        CLLocationManagerDelegate {
    
    // MARK: - Constants
    
    let currentLocationSection = 0
    
    // TODO: Вынести в отдельный менеджер или AppDelegate, чтобы получать доступ к локации со всего приложения и отслеживать его сворачивание
    let locationManager = CLLocationManager()
    
    /// "Захардкоженые" города
    let citiesData: [City] = [City(name: "Киев", location: CLLocation(latitude: 50.27, longitude: 30.31)),
                              City(name: "Львов", location: CLLocation(latitude: 49.50, longitude: 24.01)),
                              City(name: "Харьков", location: CLLocation(latitude: 49.58, longitude: 36.15)),
                              City(name: "Днепр", location: CLLocation(latitude: 48.27, longitude: 34.58)),
                              City(name: "Мариуполь", location: CLLocation(latitude: 47.5, longitude: 37.32))]
    
    
    // MARK: - Views
    
    let resultTableView = UITableView.init(frame: .zero, style: .grouped)
    
    
    // MARK: - Properties
    
    /// Текущее местоположение
    var currentLocationData = City(name: "Текущее местоположение", location: nil)
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Погода"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        view.addSubview(resultTableView)
        resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        resultTableView.refreshControl = UIRefreshControl()
        resultTableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
        
        resultTableView.showsHorizontalScrollIndicator = false
        
        updateLayout(with: view.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to: size, with: coordinator)

       coordinator.animate(alongsideTransition: { [weak self] (contex) in

           guard let size = self?.view.frame.size else { return }
           
           self?.updateLayout(with: size)

       }, completion: nil)
    }
    
    
    // MARK: - UITableView Delegate & DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       switch tableView {
           
       case tableView:
           
           if section == currentLocationSection {
               
               return 1
           } else {
               
               return citiesData.count
           }
        default:
           
           fatalError("Unknown TableView")
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        if indexPath.section == currentLocationSection {
            
            if currentLocationData.location == nil {
                
                if isLocationAuthorized() {
                    
                    cell.textLabel?.text = "Получение местоположения..."
                    cell.isUserInteractionEnabled = false
                } else {
                    
                    cell.textLabel?.text = "Местоположение недоступно"
                    cell.isUserInteractionEnabled = true
                }
            } else {
                
                cell.textLabel?.text = currentLocationData.name
                cell.isUserInteractionEnabled = true
            }
        } else {
            
            cell.textLabel?.text = citiesData[indexPath.row].name
            cell.isUserInteractionEnabled = true
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == currentLocationSection {
            
            if currentLocationData.location == nil {

                if isLocationAuthorized() {
                    
                    updateLocationIfNeeded(in: locationManager, for: currentLocationData.location)
                } else {

                    showLocationError()
                }
            } else {

                navigationController?.openWeather(inCity: currentLocationData)
            }
        } else {
            
            navigationController?.openWeather(inCity: citiesData[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocationData.location = locations.first
        
        resultTableView.refreshControl?.endRefreshing()
        resultTableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        resultTableView.reloadData()
        updateLocationIfNeeded(in: manager, for: currentLocationData.location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("\(error.localizedDescription)")
        
        resultTableView.refreshControl?.endRefreshing()
    }
    
    
    // MARK: - Methods

    private func updateLayout(with size: CGSize) {
        
        // TODO: Переписать под Autolayout
        resultTableView.frame = .init(origin: .zero, size: size)
    }
    
    
    // MARK: - Action methods
    
    @objc func handleRefreshControl() {
        
        locationManager.requestLocation()
    }
}


