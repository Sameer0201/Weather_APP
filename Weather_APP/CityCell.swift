//
//  CityCell.swift
//  Weather_APP
//
//  Created by Nagasaki on 03/05/19.
//  Copyright © 2019 Stone. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell{
    
    var city: City? {
        didSet{
            nameLabel.text = city?.name
            zipcodeLabel.text = city?.zipcode
            temperature.text = (city?.temperature!)! + "°"
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "CP"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let zipcodeLabel: UILabel = {
        let label = UILabel()
        label.text = "20740"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperature: UILabel = {
        let label = UILabel()
        label.text = "72"
        label.textAlignment = .center
        label.font = label.font.withSize(45)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(temperature)
        temperature.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        temperature.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        temperature.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        temperature.heightAnchor.constraint(equalToConstant: 50).isActive = true
        temperature.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        //nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: temperature.leftAnchor, constant: -8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(zipcodeLabel)
        zipcodeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        zipcodeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        zipcodeLabel.rightAnchor.constraint(equalTo: temperature.leftAnchor, constant: -8).isActive = true
        zipcodeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //zipcodeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
