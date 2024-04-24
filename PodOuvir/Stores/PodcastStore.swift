//
//  PodcastStore.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 13/04/24.
//

import SwiftUI

@Observable
class PodcastStore: PodcastStoreRepresentable {
    
    typealias T = Episode
    
    // MARK: - Public Variables
    
    private(set) var episodes = [T]()
    
    // MARK: - Public Methods
    
    func fetch() async throws {
        let request = URLRequest(url: Configurations.apiURL)
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        
        episodes = try decoder.decode([Episode].self, from: data)
    }
    
}

@Observable
class PodcastStoreFake: PodcastStoreRepresentable {
    
    typealias T = Episode
    
    // MARK: - Public Variables
    
    private(set) var episodes = [T]()
    
    // MARK: - Public Methods
    
    func fetch() async throws {
        guard let url = Bundle.main.url(
            forResource: "Podcasts",
            withExtension: "json"
        ) else { return }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        
        episodes = try decoder.decode([Episode].self, from: data)
    }
    
}
