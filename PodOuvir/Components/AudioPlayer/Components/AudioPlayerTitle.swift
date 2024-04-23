//
//  AudioPlayerTitle.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import SwiftUI

struct AudioPlayerTitle: View {
    let title: String
    let author: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .multilineTextAlignment(.center)
                .lineLimit(1)
            Text(author)
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
                title: sample.title,
                author: sample.author
            )
        }
    }
    
    return Example()
}
