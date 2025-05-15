//
//  CityDetailView.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import SwiftUI

struct CityDetailView: View {
    let city: City

    var body: some View {
        VStack(spacing: 20) {
            Text("\(city.name), \(city.country)")
                .font(.largeTitle)
                .padding()

            Text("Coordinates")
                .font(.headline)
            Text("Latitude: \(city.latitude)")
            Text("Longitude: \(city.longitude)")

            Spacer()
        }
        .padding()
    }
}

#Preview {
    CityDetailView(city: .init(id: 707860, name: "Hurzuf", country: "UA", latitude: 44.549999, longitude: 34.283333))
}
