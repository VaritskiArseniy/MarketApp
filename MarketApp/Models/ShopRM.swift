//
//  ShopRM.swift
//  AppTest
//
//  Created by Арсений Варицкий on 18.07.24.
//

import Foundation
import RealmSwift

class ShopRM: Object {
    @Persisted var name: String
    @Persisted var address: String
    @Persisted var city: String
    @Persisted var number: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    
    convenience init(name: String, address: String, city: String, number: String, latitude: Double, longitude: Double) {
        self.init()
        self.name = name
        self.address = address
        self.city = city
        self.number = number
        self.latitude = latitude
        self.longitude = longitude
    }
}
