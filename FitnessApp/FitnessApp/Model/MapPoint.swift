//
//  MapPoint.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 18/2/25.
//

import Foundation

class MapPoint: Identifiable, Codable {
    
    var id:String
    var name: String
    var price: Double
    var information: String
    var lat: Double
    var lon: Double
    var associate: Int
    
    init(id: String = UUID().uuidString,name: String = UUID().uuidString, price: Double, information: String, lat: Double, lon: Double,associate: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.information = information
        self.lat = lat
        self.lon = lon
        self.associate = associate
    }
    
   
}
