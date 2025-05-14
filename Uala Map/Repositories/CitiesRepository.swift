//
//  CitiesRepository.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import Foundation

protocol CitiesRepository {
    func fetchCities() async throws -> [City]
}

final class RemoteCitiesRepository: CitiesRepository {
    private let url = "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
    
    func fetchCities() async throws -> [City] {
        guard let url = URL(string: self.url) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode([CityDTO].self, from: data)
        return decoded.map { $0.toCity() }.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }
}

final class MockCitiesRepository: CitiesRepository {
    private var cities: [City] = []
    
    init(cities: [City]) {
        self.cities = cities
    }
    
    func fetchCities() async throws -> [City] { cities }
}
