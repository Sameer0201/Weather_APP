//
//  City+CoreDataProperties.swift
//  
//
//  Created by Nagasaki on 05/05/19.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var temperature: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var name: String?
    @NSManaged public var id: Int16

}
