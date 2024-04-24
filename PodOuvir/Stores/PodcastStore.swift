//
//  PodcastStore.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 13/04/24.
//

import SwiftUI

@Observable
class PodcastStore<T: Media & Decodable> {
    
    // MARK: - Public Variables
    
    private(set) var episodes = [T]()
    private(set) var isLoading = false
    
    // MARK: - Public Methods
    
    func fetch() async throws {
        isLoading = true
        
        let request = URLRequest(url: Configurations.apiURL)
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        
        isLoading = false
        episodes = try decoder.decode([T].self, from: data)
    }
    
}
