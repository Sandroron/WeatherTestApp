//
//  CityWeatherViewController.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 06.02.2022.
//

import Alamofire
import AlamofireObjectMapper
import UIKit

class CityWeatherViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource,
    DataProviderDelegate {

    // MARK: - Constants
    
    let currentWeatherSection = 0
    
    
    // MARK: - Views
    
    let resultTableView = UITableView.init(frame: .zero, style: .grouped)
    
    let loadingView = UIView.init(frame: .zero)
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    let errorView = UIView.init(frame: .zero)
    let errorStackView = UIStackView()
    let errorLabel = UILabel()
    let errorButton = UIButton()
    
    
    // MARK: - Properties
    
    var city: City?
    var dataProvider = CityWeatherDataProvider()
    
    
    // MARK: - Configuration
    
    func configure(with city: City) -> CityWeatherViewController {
        
        self.city = city
        
        return self
    }
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dataProvider.setup(with: city, delegate: self)
        dataProvider.loadData()
        
        navigationItem.title = city?.name
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(resultTableView)
        
        resultTableView.allowsSelection = false
        
        resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        resultTableView.refreshControl = UIRefreshControl()
        resultTableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
        
        resultTableView.showsHorizontalScrollIndicator = false
        
        view.addSubview(loadingView)
        
        loadingView.addSubview(activityIndicatorView)
        loadingView.backgroundColor = .systemBackground
        
        view.addSubview(errorView)
        
        errorView.backgroundColor = .systemBackground
        errorView.addSubview(errorStackView)
        
        errorStackView.axis = .vertical
        errorStackView.addArrangedSubview(errorLabel)
        errorStackView.addArrangedSubview(errorButton)
        
        errorLabel.text = "Во время загрузки возникла ошибка"
        errorLabel.textColor = .label
        errorLabel.textAlignment = .center
        
        errorButton.setTitle("Обновить", for: .normal)
        errorButton.setTitleColor(.link, for: .normal)
        errorButton.addTarget(self, action: #selector(onErrorButtonTap(_:)), for: .touchUpInside)
        
        updateLayout(with: view.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to: size, with: coordinator)

       coordinator.animate(alongsideTransition: { [weak self] (contex) in

          self?.updateLayout(with: size)

       }, completion: nil)
    }
    
    
    // MARK: - UITableView Delegate & DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
       switch tableView {
           
       case tableView:
           
           if section == currentWeatherSection {
               
               return "Сейчас"
           } else {
               
               return "Прогноз на неделю"
           }
        default:
           
           fatalError("Unknown TableView")
       }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       switch tableView {
           
       case tableView:
           
           if section == currentWeatherSection {
               
               return 1
           } else {
               
               return dataProvider.object?.daily?.count ?? 0
           }
        default:
           
           fatalError("Unknown TableView")
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        // TODO: в отдельный класс
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.positivePrefix = "+"

        let temp: String
        let main: String
        
        if indexPath.section == currentWeatherSection {
            
            temp = numberFormatter.string(for: round(dataProvider.object?.current?.temp ?? 0)) ?? ""
            main = dataProvider.object?.current?.weather?.first?.main ?? ""
        } else {
            
            temp = numberFormatter.string(for: round(dataProvider.object?.daily?[indexPath.row].temp?.average ?? 0)) ?? ""
            main = dataProvider.object?.daily?[indexPath.row].weather?.first?.main ?? ""
        }
        
        cell.textLabel?.text = "\(temp), \(main)"
        
        return cell
    }
    
    
    // MARK: - DataProviderDelegate
    
    func willShowResponseSuccess(_ dataProvider: DataProvider) {
        
        resultTableView.refreshControl?.endRefreshing()
        resultTableView.reloadData()
        
        resultTableView.isHidden = false
        loadingView.isHidden = true
        errorView.isHidden = true
        
        activityIndicatorView.stopAnimating()
    }

    func willShowResponseLoading(_ dataProvider: DataProvider) {
        
        resultTableView.isHidden = true
        loadingView.isHidden = false
        errorView.isHidden = true
        
        activityIndicatorView.startAnimating()
    }

    func willShowResponseError(_ dataProvider: DataProvider) {
        
        resultTableView.isHidden = true
        loadingView.isHidden = true
        errorView.isHidden = false
        
        activityIndicatorView.stopAnimating()
    }
    

    // MARK: - Methods

    private func updateLayout(with size: CGSize) {
        
        // TODO: Переписать под Autolayout
        resultTableView.frame = .init(origin: .zero, size: size)
        
        loadingView.frame = .init(origin: .zero, size: size)
        
        activityIndicatorView.center = loadingView.center
        
        errorView.frame = .init(origin: .zero, size: size)
        
        errorStackView.frame = .init(origin: .zero, size: CGSize(width: 320, height: 80))
        errorStackView.center = errorView.center
    }
    
    
    // MARK: - Action methods
    
    @objc func handleRefreshControl() {
        
        dataProvider.loadData()
    }
    
    @objc func onErrorButtonTap(_ sender: Any) {
        
        dataProvider.loadData()
    }
}
