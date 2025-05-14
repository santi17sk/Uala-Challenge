//
//  CityDTO.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import Foundation

struct CityDTO: Decodable {
    let _id: Int
    let name: String
    let country: String
    let coord: CoordDTO
    
    struct CoordDTO: Decodable {
        let lon: Double
        let lat: Double
    }
}

extension CityDTO {
    func toCity() -> City {
        .init(
            id: _id,
            name: name,
            country: country,
            latitude: coord.lat,
            longitude: coord.lon
        )
    }
}
