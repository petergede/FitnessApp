//
//  Locations.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 23/4/24.
//

import Foundation
import SwiftData

@Model
class Location: Identifiable {
    
    var id:String
    var name: String
    var price: Double
    var information: String
    var lat: Double
    var lon: Double
    var associate: Int
    
    init(name: String, price: Double, information: String, lat: Double, lon: Double,associate: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.price = price
        self.information = information
        self.lat = lat
        self.lon = lon
        self.associate = associate
    }
    
   
}
