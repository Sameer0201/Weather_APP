//
//  ViewController.swift
//  Weather_APP
//
//  Created by Nagasaki on 03/05/19.
//  Copyright © 2019 Stone. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import JGProgressHUD

class ViewController: UITableViewController {
    
    var cities: [City] = []
    
    public var unit = "metric"
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        
        do{
            let cities = try PersistanceService.context.fetch(fetchRequest)
            self.cities = cities
            dispatchGroup.enter()
            self.handleRefresh()
            dispatchGroup.leave()
        }catch{
            //throw JUD hud
        }
        
        //handleRefresh()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading."
        hud.show(in: view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            hud.dismiss()
            self.tableView.reloadData()
        }
        
        tableView.register(CityCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.tableFooterView = unitControl
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        
        navigationItem.title = "City"
        setupCity()
    }
    
    func handleRefresh(){
        for city in cities{
            let appid = "6b111d9f42db2c55ed9df46c3a494bfd"
            
            var path = ""
            
            path = "http://api.openweathermap.org/data/2.5/weather?id=\(city.id)&units=\(self.unit)&appid=\(appid)"
            
            Alamofire.request(path).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    //city.temperature = "0"
                    city.temperature = String(swiftyJsonVar["main"]["temp"].intValue)
                }
            }
        }
    }
    
    @objc func handleEdit(){
        tableView.isEditing = !tableView.isEditing
    }
    
    @objc func handleAdd(){
        
        let alertController = UIAlertController(title: "Enter city", message: "Enter a city name and zipcode", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Search", style: .default) { (_) in
            
            let cityName = alertController.textFields?[0].text ?? ""
            let zipcode = alertController.textFields?[1].text ?? ""
            
            self.handleAPI(cityName: cityName, zipcode: zipcode)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter City Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Zipcode"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func handleAPI(cityName: String, zipcode: String){
        let appid = "6b111d9f42db2c55ed9df46c3a494bfd"
        
        var path = ""
        
        if(cityName == "" && zipcode != ""){
            path = "http://api.openweathermap.org/data/2.5/weather?zip=\(zipcode)&units=\(unit)&appid=\(appid)"
        }else{
            path = "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=\(unit)&appid=\(appid)"
        }
        
        Alamofire.request(path).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                if(swiftyJsonVar["cod"].intValue == 404){
                    let hud = JGProgressHUD(style: .dark)
                    hud.textLabel.text = "Location not found"
                    hud.show(in: self.view)
                    hud.dismiss(afterDelay: 1.0)
                }else{
                    self.createCity(JSON: swiftyJsonVar, zipcode: zipcode)
                }
            }else{
                let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = "Location not found"
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 3.0)
            }
        }
    }
    
    func createCity(JSON: JSON, zipcode: String){
        let temperature = JSON["main"]["temp"].intValue
        let cityId = JSON["id"].intValue
        let cityName = JSON["name"].string
        let cityZipcode = zipcode
        
        let city = City(context: PersistanceService.context)
        
        city.setValue(Int32(cityId), forKey: "id")
        city.setValue(cityName!, forKey: "name")
        city.setValue(cityZipcode, forKey: "zipcode")
        city.setValue(String(temperature), forKey: "temperature")
        
        PersistanceService.saveContext()

        self.cities.append(city)
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let city = self.cities[indexPath.row]
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.updateAction(city: city, indexPath: indexPath)
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.deleteAction(city: city, indexPath: indexPath)
        }
        
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .blue
        
        return [deleteAction, editAction]
    }
    
    func updateAction(city: City, indexPath: IndexPath){
        let alertController = UIAlertController(title: "Edit Location", message: "Enter a city name and zipcode", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Search", style: .default) { (_) in
            
            let cityName = alertController.textFields?[0].text ?? ""
            let zipcode = alertController.textFields?[1].text ?? ""
            
            self.cities.remove(at: indexPath.row)
            
            PersistanceService.context.delete(city)
            
            self.handleAPI(cityName: cityName, zipcode: zipcode)
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.text = city.name
        }
        alertController.addTextField { (textField) in
            textField.text = city.zipcode
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAction(city: City, indexPath: IndexPath){
        let alertController = UIAlertController(title: "Delete City?", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            
            //let city = self.cities[indexPath.row]
            
            self.cities.remove(at: indexPath.row)
            
            PersistanceService.context.delete(city)
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CityCell
        
        let city = cities[indexPath.row]

        cell.city = city
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityForcast = CityForcastViewController()
        cityForcast.unit = self.unit
        cityForcast.currentCity = self.cities[indexPath.row]
        let navController = UINavigationController(rootViewController: cityForcast)
        present(navController, animated: true, completion: nil)
    }
    
    func setupCity(){
        if(cities.count == 0){
            let city = City(context: PersistanceService.context)
            
            city.setValue(Int32(2172797), forKey: "id")
            city.setValue("Cairns", forKey: "name")
            city.setValue("", forKey: "zipcode")
            city.setValue("24", forKey: "temperature")
            
            PersistanceService.saveContext()
            
            self.cities.append(city)
            
            self.tableView.reloadData()
        }
    }
    
    lazy var unitControl: UISegmentedControl = {
        let button = UISegmentedControl(items: ["C","F"])
        button.selectedSegmentIndex = 0
        button.addTarget(self, action: #selector(changeUnit), for: .valueChanged)
        return button
    }()
    
    @objc func changeUnit(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Changing units"
        hud.show(in: view)
        
        if(self.unit == "imperial"){
            self.unit = "metric"
        }else{
            self.unit = "imperial"
        }
        self.handleRefresh()
        PersistanceService.saveContext()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            hud.dismiss()
            self.tableView.reloadData()
        }
    }
}

