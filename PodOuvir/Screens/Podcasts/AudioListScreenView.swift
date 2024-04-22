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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.sections) { section in
                    Section("\(section.year.description)") {
                        ForEach(section.episodes) { episode in
                            NavigationLink {
                                AudioPlayerView<Episode>(
                                    items: store.episodes,
                                    selected: episode,
                                    autoplay: false
                                )
                            } label: {
                                Text(episode.title)
                            }
                        }
                    }
                }
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
