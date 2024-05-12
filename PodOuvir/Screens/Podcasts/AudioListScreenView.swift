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
    
    private let subscriptionManager = SubscriptionManager.shared
    
    @State private var selection: T?
    @State private var isPresentPlayer = false
    @State private var isPresentSubscription = false
    
    private var autoplay = false
    
    var body: some View {
        ZStack {
            if store.isLoading {
                ProgressView()
            } else if !store.episodes.isEmpty {
                ScrollViewReader { proxy in
                    VStack {
                        List(
                            store.episodes,
                            id: \.self
                        ) { episode in
                            Button {
                                selection = episode
                                isPresentPlayer.toggle()
                            } label: {
                                Text(episode.title)
                            }
                            .id(episode)
                        }
                        .onChange(of: selection) { oldValue, newValue in
                            proxy.scrollTo(newValue)
                        }
                        
                        if !subscriptionManager.hasPremium {
                            Button {
                                isPresentSubscription.toggle()
                            } label: {
                                Text("Get a premium account")
                            }
                            .safeAreaPadding()
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isPresentSubscription) {
            SubscriptionScreenView()
        }
        .fullScreenCover(isPresented: $isPresentPlayer) {
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
