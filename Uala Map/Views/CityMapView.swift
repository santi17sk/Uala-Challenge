//
//  CityMapView.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import SwiftUI
import MapKit

struct CityMapView: View {
    let city: City
    
    @State private var position: MapCameraPosition
    
    init(city: City) {
        self.city = city
        let center = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        _position = State(initialValue: .region(MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )))
    }
    
    var body: some View {
        Map(position: $position)
            .navigationTitle("\(city.name), \(city.country)")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CityMapView(city: .init(id: 707860, name: "Hurzuf", country: "UA", latitude: 44.549999, longitude: 34.283333))
}
