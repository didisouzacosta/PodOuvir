//
//  Media.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import Foundation

protocol Media: Cover, Equatable {
    var id: String { get }
    var url: URL { get }
    var title: String { get }
    var artworkURL: URL { get }
    var artist: String? { get }
    var duration: Double { get }
}

extension Media {
    
    var episode: String { id }
    var midiaURL: URL { artworkURL }
    
}
