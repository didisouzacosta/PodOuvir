//
//  AudioPlayerTitle.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import SwiftUI

struct AudioPlayerTitle: View {
    let episode: String
    let title: String
    let artist: String?
    
    var body: some View {
        VStack {
            Text(episode)
                .font(.caption)
                .lineLimit(1)
            Text(title)
                .font(.title2)
                .multilineTextAlignment(.center)
                .lineLimit(1)
            Text(artist ?? "...")
                .font(.subheadline)
                .lineLimit(1)
                .foregroundStyle(.gray)
        }
        .contentTransition(.numericText())
    }
}

#Preview {
    struct Example: View {
        private let sample = episodes[0]
        
        var body: some View {
            AudioPlayerTitle(
                episode: sample.id,
                title: sample.title,
                artist: sample.artist
            )
        }
    }
    
    return Example()
}
