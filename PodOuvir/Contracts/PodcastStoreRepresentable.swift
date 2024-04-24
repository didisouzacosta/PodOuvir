//
//  PodcastStoreRepresentable.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 24/04/24.
//

import Foundation

protocol PodcastStoreRepresentable {
    associatedtype T: Media
    
    var episodes: [T] { get }
    
    func fetch() async throws
}
