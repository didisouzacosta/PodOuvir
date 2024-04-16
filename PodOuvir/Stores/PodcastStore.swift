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
    
    var sections: [SectionItems] {
        get {
            _sections.sorted(by: { $0.year > $1.year })
        }
    }
    
    // MARK: - Private Variables
    
    private var _sections: [SectionItems] = []
    
    // MARK: - Public Methods
    
    func fetch() async throws {
        guard let url = Bundle.main.url(forResource: "Podcasts", withExtension: "json") else { return }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        
        self._sections = try decoder.decode([SectionItems].self, from: data)
    }
    
}
