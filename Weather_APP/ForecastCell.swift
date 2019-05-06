//
//  ForecastCell.swift
//  Weather_APP
//
//  Created by Nagasaki on 04/05/19.
//  Copyright © 2019 Stone. All rights reserved.
//

import UIKit
import SDWebImage

class ForecastCell: UITableViewCell {

    var dayForecast: DailyForecast? {
        didSet{
            setImage(iconID: dayForecast?.icon ?? "")
            dayLabel.text = dayOfWeek(date: dayForecast?.date ?? Date.init())
            maxTemp.text = (dayForecast?.max_temp)! + "°"
            minTemp.text = (dayForecast?.min_temp)! + "°"
            
            //nameLabel.text = city?.name
            //zipcodeLabel.text = city?.zipcode
            //temperature.text = city?.weather.temperature
        }
    }
    
    func setImage(iconID: String){
        
        
        let imageUrl = "http://openweathermap.org/img/w/\(iconID).png"
        
        if let url = URL(string: imageUrl) {
            iconImage.sd_setImage(with: url)
        }
    }
    
    func dayOfWeek(date: Date) -> String{
        
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: date)
        
        switch weekDay{
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return "Sunday"
        }
    }
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Monday"
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maxTemp: UILabel = {
        let label = UILabel()
        label.text = "85"
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minTemp: UILabel = {
        let label = UILabel()
        label.text = "45"
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //self.backgroundColor = .red
        
        let stackView = UIStackView(arrangedSubviews: [
            dayLabel,
            iconImage,
            minTemp,
            maxTemp
            ])
        
        stackView.axis = .horizontal
        stackView.spacing = 2
        //stackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        //stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(dayLabel)
        dayLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        dayLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        dayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(iconImage)
        iconImage.leftAnchor.constraint(equalTo: dayLabel.rightAnchor, constant: 16).isActive = true
        iconImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        iconImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(minTemp)
        minTemp.leftAnchor.constraint(equalTo: iconImage.rightAnchor, constant: 16).isActive = true
        minTemp.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        minTemp.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        minTemp.heightAnchor.constraint(equalToConstant: 25).isActive = true
        minTemp.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(maxTemp)
        maxTemp.leftAnchor.constraint(equalTo: minTemp.rightAnchor, constant: 8).isActive = true
        maxTemp.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
        maxTemp.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        maxTemp.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        maxTemp.heightAnchor.constraint(equalToConstant: 25).isActive = true
        maxTemp.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
