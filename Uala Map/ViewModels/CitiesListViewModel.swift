//
//  CitiesListViewModel.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import Foundation

final class CitiesListViewModel: ObservableObject {
    @Published private(set) var cities: [City] = []
    
    private let repository: CitiesRepository
    private let favouritesStore: FavouritesStore
    
    init(
        repository: CitiesRepository = RemoteCitiesRepository(),
        favouritesStore: FavouritesStore = UserDefaultsFavouritesStore()
    ) {
        self.repository = repository
        self.favouritesStore = favouritesStore
    }
    
    func loadCities() async {
        do {
            cities = try await repository.fetchCities()
        } catch {
            print("Error loading cities: \(error)")
        }
    }
}
