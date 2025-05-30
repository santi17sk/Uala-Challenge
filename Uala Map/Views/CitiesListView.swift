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
    @State private var selectedCityForInfo: City?
    @State private var navigateToMap: Bool = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    if viewModel.isLoading {
                        ForEach(0..<5, id: \.self) { _ in
                            CitySkeletonRowView()
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color(uiColor: .systemBackground))
                        }
                    } else {
                        ForEach(viewModel.filteredCities) { city in
                            CityRowView(
                                city: city,
                                onFavoriteToggle: {
                                    viewModel.toggleFavorite(for: city)
                                },
                                onInfoTapped: {
                                    selectedCityForInfo = city
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
                            .onAppear {
                                viewModel.loadMoreIfNeeded(currentItem: city)
                            }
                            
                            if city.id != viewModel.filteredCities.last?.id {
                                Divider()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Cities")
            .searchable(text: $viewModel.searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Toggle(isOn: $viewModel.showFavoritesOnly) {
                        Image(systemName: viewModel.showFavoritesOnly ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToMap) {
                if let city = selectedCity {
                    CityMapView(city: city)
                }
            }
            .overlay {
                if viewModel.loadError {
                    ConnectionErrorView {
                        viewModel.reloadCities()
                    }
                } else if viewModel.filteredCities.isEmpty {
                    if viewModel.showFavoritesOnly {
                        ContentUnavailableView(
                            "No Favorites",
                            systemImage: "star.slash",
                            description: Text("You haven't marked any city as favorite yet.")
                        )
                    } else if !viewModel.searchText.isEmpty {
                        ContentUnavailableView.search(text: viewModel.searchText)
                    } else if !viewModel.isLoading {
                        ContentUnavailableView(
                            "No Cities",
                            systemImage: "globe",
                            description: Text("There are no cities to show.")
                        )
                    }
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
        .sheet(item: $selectedCityForInfo) { city in
            CityDetailView(city: city)
        }
        .task {
            await viewModel.loadCities()
        }
    }
}

#Preview {
    CitiesListView(viewModel: .init(repository: MockCitiesRepository(cities: [
        .init(id: 707860, name: "Hurzuf", country: "UA", latitude: 44.549999, longitude: 34.283333),
        .init(id: 519188, name: "Novinki", country: "RU", latitude: 55.683334, longitude: 37.666668)]), favouritesStore: InMemoryFavouritesStore()))
}
