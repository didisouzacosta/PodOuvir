//
//  Episode.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 15/04/24.
//

import Foundation

struct Episode: Decodable, Media {
    let title: String
    let author: String
    let url: URL
    let image: URL
    let duration: Double
}

extension Episode {
    
    var id: String {
        url.absoluteString
    }
    
}
