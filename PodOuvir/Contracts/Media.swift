//
//  Media.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import Foundation

protocol Media: Cover, Equatable {
    var title: String { get }
    var author: String { get }
    var url: URL { get }
    var image: URL { get }
    var duration: Double { get }
}

extension Media {
    
    var imageURL: URL {
        image
    }
    
}
