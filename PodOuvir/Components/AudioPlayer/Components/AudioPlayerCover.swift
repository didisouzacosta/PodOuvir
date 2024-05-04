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
    var loadedImageHandler: ((UIImage) -> Void)?
    
    var body: some View {
        Rectangle().fill(.background)
            .overlay {
                ImageView(
                    url: item.imageURL,
                    loadedImageHandler: loadedImageHandler
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    return AudioPlayerCover(item: episodes[0])
}
