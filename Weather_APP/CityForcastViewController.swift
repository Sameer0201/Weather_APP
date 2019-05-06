//
//  CityForcastViewController.swift
//  Weather_APP
//
//  Created by Nagasaki on 04/05/19.
//  Copyright © 2019 Stone. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CityForcastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let dispatchGroup = DispatchGroup()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForecast", for: indexPath) as! ForecastCell
        
        //cell.backgroundColor = .red
        
        let dayForecast = forecast[indexPath.row]
        
        cell.dayForecast = dayForecast
        
        return cell
    }
    
    
    var currentCity: City?{
        didSet{
            cityNameLabel.text = currentCity?.name
            temperature.text = (currentCity?.temperature)! + "°"
            handleAPI(cityID: (currentCity?.id)!)
        }
    }
    
    var unit: String = "imperial"{
        didSet{
        }
    }

    var forecast = [DailyForecast]()
    
    var tableView: UITableView?
    var topView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Daily Forecast"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        tableView = UITableView(frame:CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 736), style: UITableView.Style.plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.register(ForecastCell.self, forCellReuseIdentifier: "CellForecast")
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250))
        
        let stackView = UIStackView(arrangedSubviews: [
            cityNameLabel,
            temperature
            ])
        
        topView?.addSubview(stackView)
        
        tableView?.tableHeaderView = topView
        tableView?.tableFooterView = UIView()
        
        view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        //view.addSubview(stackView)
        
        view.addSubview(tableView!)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        stackView.centerYAnchor.constraint(equalTo: topView!.centerYAnchor).isActive = true
        
    }
    
    @objc func handleBack(){
        dismiss(animated: true, completion: nil)
    }
    
    private let cityNameLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "CP"
        label.font = label.font.withSize(55)
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperature: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "72"
        label.font = label.font.withSize(100)
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func handleAPI(cityID: Int32){
        dispatchGroup.enter()
        
        let appid = "6b111d9f42db2c55ed9df46c3a494bfd"
        let path =  "http://api.openweathermap.org/data/2.5/forecast?id=\(cityID)&units=\(self.unit)&appid=\(appid)"
        
        Alamofire.request(path).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                self.parseForcast(JSON: swiftyJsonVar)
                self.dispatchGroup.leave()
                self.tableView?.reloadData()
            }
        }
    }
    
    func parseForcast(JSON: JSON){
        let list = JSON["list"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"

        var counter = 0
        
        for i in 0..<list.count{
            if counter == 0{
                
                let date = dateFormatter.date(from: list[i]["dt_txt"].string!)
                let min_temp = list[i]["main"]["temp_min"].int
                let max_temp = list[i]["main"]["temp_max"].int
                let icon = list[i]["weather"][0]["icon"].string!
                
                let dailyForcast = DailyForecast(date: date!, icon: icon, max_temp: String(max_temp!), min_temp: String(min_temp!))
                
                self.forecast.append(dailyForcast)
                
            }
            counter = counter + 1
            if counter == 8{
                 counter = 0
            }
        }
    }
}
