//
//  Models.swift
//  Weather_APP
//
//  Created by Nagasaki on 03/05/19.
//  Copyright © 2019 Stone. All rights reserved.
//

import Foundation

class Cityz{
    let id: Int
    let name: String
    let zipcode: String
    let temperature: String
    
    init(id: Int, name: String, zipcode: String, temperature: String){
        self.id = id
        self.name = name
        self.zipcode = zipcode
        self.temperature = temperature
    }
}

class DailyForecast{
    let date: Date
    let icon: String
    let max_temp: String
    let min_temp: String
    
    init(date: Date, icon: String, max_temp: String, min_temp:String){
        self.date = date
        self.icon = icon
        self.max_temp = max_temp
        self.min_temp = min_temp
    }
}
