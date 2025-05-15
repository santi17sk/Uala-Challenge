//
//  Uala_MapTests.swift
//  Uala MapTests
//
//  Created by santiago.tito on 15/05/2025.
//

import Testing
@testable import Uala_Map

@MainActor
struct Uala_MapTests {
    
    private func makeSUT() -> CitiesListViewModel {
        let cities = [
            City(id: 1, name: "Buenos Aires", country: "AR", latitude: -34.6, longitude: -58.38),
            City(id: 2, name: "Barcelona", country: "ES", latitude: 41.38, longitude: 2.17),
            City(id: 3, name: "New York", country: "US", latitude: 40.71, longitude: -74.00),
            City(id: 4, name: "Berlin", country: "DE", latitude: 52.52, longitude: 13.40)
        ]
        let repository = MockCitiesRepository(cities: cities)
        let store = InMemoryFavouritesStore()
        return CitiesListViewModel(repository: repository, favouritesStore: store)
    }
    
    @Test("Should return matching cities for valid input")
    func test_search_withValidInput_shouldReturnMatchingCities() async throws {
        let viewModel = makeSUT()
        await viewModel.loadCities()
        
        await MainActor.run { viewModel.searchText = "B" }
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        let names = viewModel.filteredCities.map { $0.name }
        #expect(names == ["Barcelona", "Berlin", "Buenos Aires"])
    }
    
    @Test("Should return empty for input with no matches")
    func test_search_withInvalidInput_shouldReturnEmpty() async throws {
        let viewModel = makeSUT()
        await viewModel.loadCities()
        
        await MainActor.run { viewModel.searchText = "X" }
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        #expect(viewModel.filteredCities.isEmpty)
    }
    
    @Test("Should return all cities for empty input")
    func test_search_withEmptyInput_shouldReturnAllCities() async throws {
        let viewModel = makeSUT()
        await viewModel.loadCities()
        
        await MainActor.run { viewModel.searchText = "" }
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        let names = viewModel.filteredCities.map { $0.name }
        #expect(names == ["Barcelona", "Berlin", "Buenos Aires", "New York"])
    }
    
    @Test("Should be case insensitive for search")
    func test_search_shouldBeCaseInsensitive() async throws {
        let viewModel = makeSUT()
        await viewModel.loadCities()
        
        await MainActor.run { viewModel.searchText = "b" }
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        let names = viewModel.filteredCities.map { $0.name }
        #expect(names == ["Barcelona", "Berlin", "Buenos Aires"])
    }
}
