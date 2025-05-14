//
//  FavouritesStore.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import Foundation

protocol FavouritesStore {
    func get() -> Set<Int>
    func save(_ ids: Set<Int>)
}

final class UserDefaultsFavouritesStore: FavouritesStore {
    private let key = "favouriteCities"
    
    func get() -> Set<Int> {
        let ids = UserDefaults.standard.array(forKey: key) as? [Int] ?? []
        return Set(ids)
    }
    
    func save(_ ids: Set<Int>) {
        UserDefaults.standard.set(Array(ids), forKey: key)
    }
}

final class InMemoryFavouritesStore: FavouritesStore {
    private(set) var ids: Set<Int> = []
    
    func get() -> Set<Int> { ids }
    
    func save(_ ids: Set<Int>) { self.ids = ids }
}
