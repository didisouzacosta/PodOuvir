//
//  PodcastStore.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 13/04/24.
//

import SwiftUI

@Observable
class PodcastStore {
    
    // MARK: - Public Variables
    
    private(set) var episodes: [Episode] = []
    
    // MARK: - Private Variables
    
    // MARK: - Public Methods
    
    func index(of item: Episode) -> Int {
        episodes.firstIndex(of: item) ?? 0
    }
    
    func fetch() async throws {
        guard let url = Bundle.main.url(forResource: "Podcasts", withExtension: "json") else { return }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        
        episodes = try decoder.decode([Episode].self, from: data)
    }
    
}
