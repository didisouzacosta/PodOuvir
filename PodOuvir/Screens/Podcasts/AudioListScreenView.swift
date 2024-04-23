//
//  AudioListScreenView.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 13/04/24.
//

import SwiftUI

struct AudioListScreenView: View {
    
    @Environment(PodcastStore.self) private var store
    
    @State private var currentIndex = 0
    @State private var path: [Episode] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(store.sections) { section in
                    Section("\(section.year.description)") {
                        ForEach(section.episodes) { episode in
                            NavigationLink(value: episode) {
                                Text(episode.title)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Episode.self) { episode in
                AudioPlayerView(
                    items: store.episodes,
                    selection: episode,
                    autoplay: true
                )
            }
        }
        .onAppear {
            Task {
                do {
                    try await store.fetch()
                } catch {
                    print("Erro a carregar dados: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    AudioListScreenView()
        .environment(PodcastStore())
}
