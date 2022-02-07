//
//  CityWeatherTableViewCell.swift
//  WeatherTestApp
//
//  Created by Razumnyi Aleksandr on 07.02.2022.
//

import UIKit

class CityWeatherTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // MARK: - Methods
    
    func setup(temp: Int, main: String) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.positivePrefix = "+"

        let tempFormatted = numberFormatter.string(for: temp) ?? ""
        
        // TODO: Дата
        textLabel?.text = "\(tempFormatted), \(main)"
    }
}
