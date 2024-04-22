//
//  Media.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import Foundation

protocol Media: Equatable, Hashable {
    var id: String { get }
    var url: URL { get }
    var title: String { get }
    var artist: String? { get }
    var artworkURL: URL? { get }
}

extension Media {
    
    var episode: String { id }
    
}
