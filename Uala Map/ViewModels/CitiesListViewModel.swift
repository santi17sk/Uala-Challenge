//
//  CitiesListViewModel.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import Foundation

@MainActor
final class CitiesListViewModel: ObservableObject {
    @Published private(set) var cities: [City] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var loadError: Bool = false
    
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
        isLoading = true
        loadError = false
        defer { isLoading = false }
        
        do {
            cities = try await repository.fetchCities()
        } catch {
            loadError = true
        }
    }
    
    func reloadCities() {
        Task {
            await loadCities()
        }
    }
}
