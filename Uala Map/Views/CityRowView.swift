//
//  CityRowView.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import SwiftUI

struct CityRowView: View {
    let city: City
    let onFavoriteToggle: () -> Void
    let onInfoTapped: () -> Void
    let onRowTapped: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(city.name), \(city.country)")
                    .font(.headline)
                Text("Lat: \(city.latitude), Lon: \(city.longitude)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: onFavoriteToggle) {
                Image(systemName: city.isFavorite ? "star.fill" : "star")
                    .foregroundColor(city.isFavorite ? .yellow : .gray)
            }
            .buttonStyle(.plain)
            Button(action: onInfoTapped) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onRowTapped()
        }
    }
}

#Preview {
    CityRowView(city: City(id: 1, name: "Alabama", country: "US", latitude: 32.806671, longitude: -86.791130), onFavoriteToggle: {}, onInfoTapped: {}, onRowTapped: {})
}
