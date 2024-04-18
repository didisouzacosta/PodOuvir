//
//  Media.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import Foundation

protocol Media: Equatable, Hashable {
    var url: URL { get }
    var title: String? { get }
    var artist: String? { get }
    var artworkUrl: URL? { get }
}
