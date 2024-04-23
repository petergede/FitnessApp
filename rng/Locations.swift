//
//  Locations.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 23/4/24.
//

import Foundation
import SwiftData

@Model
class Location:  ObservableObject {
    var name: String
    var price: Double
    var information: String
    var lat: String
    var lang: String
    
    init(name: String, price: Double, information: String, lat: String, lang: String) {
        self.name = name
        self.price = price
        self.information = information
        self.lat = lat
        self.lang = lang
    }
   
}
