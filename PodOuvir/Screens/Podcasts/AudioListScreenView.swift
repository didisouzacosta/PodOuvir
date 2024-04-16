//
//  AudioListScreenView.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 13/04/24.
//

import SwiftUI

struct AudioListScreenView: View {
    
    @Environment(PodcastStore.self) private var store
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.sections) { section in
                    Section("\(section.year.description)") {
                        ForEach(section.items) { item in
                            NavigationLink(destination: AudioPlayerView(media: item)) {
                                Text(item.title ?? "---")
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
