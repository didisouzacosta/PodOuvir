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
    
    var sections: [EpisodesSection] {
        _sections.sorted(by: { $0.year > $1.year })
    }
    
    var episodes: [Episode] {
        sections.flatMap { $0.episodes }
    }
    
    // MARK: - Private Variables
    
    private var _sections: [EpisodesSection] = []
    
    // MARK: - Public Methods
    
    func index(of item: Episode) -> Int {
        episodes.firstIndex(of: item) ?? 0
    }
    
    func fetch() async throws {
        guard let url = Bundle.main.url(forResource: "Podcasts", withExtension: "json") else { return }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        
        self._sections = try decoder.decode([EpisodesSection].self, from: data)
    }
    
}
