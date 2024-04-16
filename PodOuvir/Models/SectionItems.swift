//
//  SectionItems.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 15/04/24.
//

import Foundation

struct SectionItems: Decodable, Identifiable {
    let id = UUID()
    let year: Int
    let items: [Item]
    
    enum CodingKeys: CodingKey {
        case year
        case items
    }
}
