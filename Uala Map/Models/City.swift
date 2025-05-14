//
//  City.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import Foundation

class City {
    let id: Int
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    var isFavorite: Bool = false
    
    init(id: Int, name: String, country: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
}
