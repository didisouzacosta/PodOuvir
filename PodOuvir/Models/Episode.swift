//
//  Episode.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 15/04/24.
//

import Foundation

struct Episode: Decodable, Media {
    let id: String
    let title: String
    let artist: String?
    let url: URL
    let artworkURL: URL
}

struct EpisodesSection: Decodable, Identifiable {
    let year: Int
    let episodes: [Episode]
    
    var id: Int { year }
}
