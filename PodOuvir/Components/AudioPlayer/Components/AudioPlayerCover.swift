//
//  AudioPlayerCover.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 18/04/24.
//

import SwiftUI
import Foundation
import SDWebImageSwiftUI

protocol Cover: Hashable, Identifiable {
    var imageURL: URL { get }
}

struct AudioPlayerCover<T: Cover>: View {
    
    // MARK: - Public Variables
    
    let item: T
    var handler: ImageView.Handler?
    
    var body: some View {
        Rectangle().fill(.background)
            .overlay {
                ImageView(
                    url: item.imageURL,
                    handler: handler
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .aspectRatio(1, contentMode: .fit)
            .shadow(radius: 30, y: 10)
    }
}

#Preview {
    return AudioPlayerCover(item: episodes[0])
}
