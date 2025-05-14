//
//  CitiesListView.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import SwiftUI

struct CitiesListView: View {
    @StateObject var viewModel = CitiesListViewModel()
    @State private var selectedCity: City?
    @State private var navigateToMap: Bool = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.cities) { city in
                        CityRowView(
                            city: city,
                            onFavoriteToggle: {
                                print("add to favorite \(city.name)")
                            },
                            onInfoTapped: {
                                print("info tapped for \(city.name)")
                            },
                            onRowTapped: {
                                selectedCity = city
                                if horizontalSizeClass == .compact {
                                    navigateToMap = true
                                }
                            }
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(uiColor: .systemBackground))
                        
                        if city.id != viewModel.cities.last?.id {
                            Divider()
                        }
                    }
                }
            }
            .navigationTitle("Cities")
            .navigationDestination(isPresented: $navigateToMap) {
                if let city = selectedCity {
                    CityMapView(city: city)
                }
            }
        } detail: {
            if let city = selectedCity {
                CityMapView(city: city)
                    .id(city.id)
            } else {
                Text("Select a city")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
        .task {
            await viewModel.loadCities()
        }
    }
}

#Preview {
    CitiesListView(viewModel: .init(repository: MockCitiesRepository(cities: [
        .init(id: 707860, name: "Hurzuf", country: "UA", latitude: 44.549999, longitude: 34.283333),
        .init(id: 519188, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668)
        ,
        .init(id: 5191818, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668),
        .init(id: 1, name: "Hurzuf", country: "UA", latitude: 44.549999, longitude: 34.283333),
        .init(id: 2, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668)
        ,
        .init(id: 3, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668),
        .init(id: 4, name: "Hurzuf", country: "UA", latitude: 44.549999, longitude: 34.283333),
        .init(id: 5, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668)
        ,
        .init(id: 6, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668)
        ,
        .init(id: 7, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668),
        .init(id: 8, name: "Hurzuf", country: "UA", latitude: 44.549999, longitude: 34.283333),
        .init(id: 9, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668)
        ,
        .init(id: 10, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668)
        ,
        .init(id: 11, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668),
        .init(id: 12, name: "Hurzuf", country: "UA", latitude: 44.549999, longitude: 34.283333),
        .init(id: 13, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668)
        ,
        .init(id: 14, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668)
        
    ]), favouritesStore: InMemoryFavouritesStore()))
}
