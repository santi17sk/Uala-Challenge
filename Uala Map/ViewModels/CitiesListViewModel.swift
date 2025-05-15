//
//  CitiesListViewModel.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import Foundation

@MainActor
final class CitiesListViewModel: ObservableObject {
    @Published var searchText: String = "" {
        didSet { debounceSearch() }
    }
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var loadError: Bool = false
    @Published private(set) var filteredCities: [City] = []
    
    private let repository: CitiesRepository
    private let favouritesStore: FavouritesStore
    private var favouriteIDs: Set<Int> = []
    
    private var trie: CityTrie?
    private var displayedCities: [City] = []
    private var cities: [City] = []
    private var searchWorkItem: DispatchWorkItem?
    
    private let pageSize = 100
    private var currentPage = 0
    
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
            loadFavourites()
            applyFavourites()
            displayedCities = Array(cities.prefix(pageSize))
            currentPage = 1
            
            let trie = CityTrie()
            for city in cities { trie.insert(city) }
            self.trie = trie
            
            applyFilters()
        } catch {
            loadError = true
        }
    }
    
    func reloadCities() {
        Task {
            await loadCities()
        }
    }
    
    func loadMoreIfNeeded(currentItem city: City) {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedSearch.isEmpty else { return }
        guard let lastItem = displayedCities.last else { return }
        if city.id == lastItem.id {
            loadMore()
        }
    }
    
    private func loadMore() {
        let startIndex = currentPage * pageSize
        let endIndex = min(startIndex + pageSize, cities.count)
        guard startIndex < endIndex else { return }
        
        displayedCities.append(contentsOf: cities[startIndex..<endIndex])
        currentPage += 1
        applyFilters()
    }
    
    private func applyFilters() {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedSearch.isEmpty {
            let matchingIds = Set(trie?.search(prefix: trimmedSearch).map { $0.id } ?? [])
            filteredCities = cities
                .filter { matchingIds.contains($0.id) }
                .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                .prefix(100)
                .map { $0 }
        } else {
            filteredCities = displayedCities
                .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }
    
    private func debounceSearch() {
        searchWorkItem?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.applyFilters()
        }
        searchWorkItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
    
    func toggleFavorite(for city: City) {
        guard let index = cities.firstIndex(where: { $0.id == city.id }) else { return }
        cities[index].isFavorite.toggle()
        
        if cities[index].isFavorite {
            favouriteIDs.insert(cities[index].id)
        } else {
            favouriteIDs.remove(cities[index].id)
        }
        applyFilters()
        saveFavourites()
    }
    
    private func saveFavourites() {
        favouritesStore.save(favouriteIDs)
    }
    
    private func loadFavourites() {
        favouriteIDs = favouritesStore.get()
    }
    
    private func applyFavourites() {
        for i in 0..<cities.count {
            cities[i].isFavorite = favouriteIDs.contains(cities[i].id)
        }
    }
}
