//
//  AudioPlayerCover.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import SwiftUI

struct AudioPlayerCover: View {
    let artworkUrl: URL?
    
    var body: some View {
        Rectangle()
            .overlay {
                AsyncImage(url: artworkUrl) { phase in
                    phase.image?.resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(minHeight: 200)
            .padding()
            .clipped()
    }
}

#Preview {
    AudioPlayerCover(artworkUrl: fakePodcast.artworkUrl)
}
