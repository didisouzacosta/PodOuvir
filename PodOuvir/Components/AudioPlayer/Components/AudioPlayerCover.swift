//
//  AudioPlayerCover.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 18/04/24.
//

import SwiftUI
import Foundation

protocol Cover: Hashable, Identifiable {
    var imageURL: URL { get }
}

struct AudioPlayerCover<T: Cover>: View {
    
    // MARK: - Public Variables
    
    let item: T
    
    var body: some View {
        ImageView(url: item.imageURL)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .aspectRatio(1, contentMode: .fit)
            .padding()
            .containerRelativeFrame(.horizontal)
    }
}

#Preview {
    return AudioPlayerCover(item: episodes[0])
}
