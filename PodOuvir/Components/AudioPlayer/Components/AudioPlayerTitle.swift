//
//  AudioPlayerTitle.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import SwiftUI

struct AudioPlayerTitle: View {
    let title: String?
    let artist: String?
    
    var body: some View {
        VStack {
            Text(title ?? "...")
                .font(.title)
            Text(artist ?? "...")
                .font(.title3)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    AudioPlayerTitle(title: "Alan Wake", artist: "Remedy")
}
