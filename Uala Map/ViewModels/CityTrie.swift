//
//  CityTrie.swift
//  Uala Map
//
//  Created by santiago.tito on 15/05/2025.
//

import Foundation

extension CitiesListViewModel {
    final class CityTrieNode {
        var children: [Character: CityTrieNode] = [:]
        var cities: [City] = []
    }
    
    /// --------------------------------------------------------------
    /// 💡 Search optimization note (as requested by challenge brief)
    ///
    /// The dataset of cities (~200,000 records) is preprocessed into a
    /// custom Trie data structure (`CityTrie`) to optimize search performance.
    ///
    /// Why a Trie?
    /// - Traditional linear search has a time complexity of O(n), where n = total cities
    /// - A Trie reduces this to O(m), where m = length of the prefix
    /// - In our case, this means the search remains extremely fast even for massive datasets
    /// - Each character of the search prefix traverses a level of the Trie
    ///
    /// Additional advantages:
    /// - Efficient memory usage: common prefixes share nodes
    /// - Scalable for large real-world datasets
    ///
    /// This approach guarantees the "The UI should be as responsive as possible while typing in a filter" requirement.
    /// --------------------------------------------------------------
    final class CityTrie {
        private let root = CityTrieNode()
        
        func insert(_ city: City) {
            let lowercasedName = city.name.lowercased()
            var node = root
            
            for char in lowercasedName {
                if node.children[char] == nil {
                    node.children[char] = CityTrieNode()
                }
                node = node.children[char]!
                node.cities.append(city)
            }
        }
        
        func search(prefix: String) -> [City] {
            let lowercasedPrefix = prefix.lowercased()
            var node = root
            
            for char in lowercasedPrefix {
                guard let nextNode = node.children[char] else {
                    return []
                }
                node = nextNode
            }
            return node.cities
        }
    }
}
