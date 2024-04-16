//
//  Item.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 15/04/24.
//

import Foundation

struct Item: Decodable, Identifiable, AudioPlayer.Media {
    let id = UUID()
    let title: String?
    let artist: String?
    let url: URL
    let artworkUrl: URL?
    
    enum CodingKeys: CodingKey {
        case title
        case artist
        case url
        case artworkUrl
    }
}
