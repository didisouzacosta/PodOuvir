//
//  AudioListScreenView.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 13/04/24.
//

import SwiftUI

struct AudioListScreenView: View {
    
    typealias T = Episode
    
    @Environment(PodcastStore<T>.self) private var store
    
    @State private var selection: T?
    @State private var isPresent = false
    
    private var autoplay = false
    
    var body: some View {
        Group {
            if store.isLoading {
                ProgressView()
            } else {
                ScrollViewReader { proxy in
                    List(
                        store.episodes,
                        id: \.self
                    ) { episode in
                        Button {
                            selection = episode
                            isPresent.toggle()
                        } label: {
                            Text(episode.title)
                        }
                        .id(episode)
                    }
                    .onChange(of: selection) { oldValue, newValue in
                        proxy.scrollTo(newValue)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isPresent) {
            AudioPlayerView(
                items: store.episodes,
                selection: $selection,
                autoplay: autoplay
            )
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
        .environment(PodcastStore<Episode>())
}
