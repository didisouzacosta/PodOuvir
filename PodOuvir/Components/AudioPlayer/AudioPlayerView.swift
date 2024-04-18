//
//  AudioPlayerView.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 13/04/24.
//

import SwiftUI

struct AudioPlayerView<T: Media>: View {
    
    // MARK: - Private Variables
    
    private let audioPlayer = AudioPlayer<T>()
    
    @State private var currentTime: Double = 0
    @State private var isPlaying = false
    @State private var selectedItem: URL?
    
    private var currentMedia: T {
        items[currentIndex]
    }
    
    private var artworks: [URL] {
        items.compactMap { $0.artworkUrl }
    }
    
    // MARK: - Public Variables
    
    @Binding var currentIndex: Int
    
    let items: [T]
    let autoplay: Bool
    
    var body: some View {
        VStack {
            Spacer()
            AudioPlayerCover(
                artworks: artworks,
                selectedItem: $selectedItem,
                currentIndex: $currentIndex
            )
            
            VStack(spacing: 16) {
                AudioPlayerTitle(
                    title: currentMedia.title,
                    artist: currentMedia.artist
                )
                .frame(height: 80)
                
                AudioPlayerSeekBar(
                    currentTime: $currentTime,
                    totalTime: audioPlayer.totalTime
                ) { time in
                    audioPlayer.seek(to: time)
                    audioPlayer.play()
                } stopHandler: {
                    audioPlayer.stop()
                }.onChange(of: audioPlayer.currentTime) { _, newValue in
                    currentTime = newValue
                }
                
                AudioPlayerControls(
                    isPlaying: $isPlaying,
                    playHandler: { audioPlayer.play() },
                    pauseHandler: { audioPlayer.pause() },
                    backwardHandler: { audioPlayer.backward() },
                    forwardHandler: { audioPlayer.forward() }
                ).onChange(of: audioPlayer.isPlaying) { _, newValue in
                    self.isPlaying = newValue
                }
            }
            .padding()
            .onChange(of: currentMedia, initial: true) { _, newValue in
                Task {
                    try? await prepare(media: newValue)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func prepare(media: T) async throws {
        guard media != audioPlayer.currentItem else { return }
        
        try await audioPlayer.load(media: media)
        
        guard autoplay else { return }
        
        audioPlayer.play()
    }
}

#Preview {
    struct Example: View {
        @State var currentIndex = 0
        
        @State var items: [Item] = [
            zeldaTOTKSample,
            donkeyKongSample,
            alanWakeSample
        ]
        
        var body: some View {
            AudioPlayerView<Item>(
                currentIndex: $currentIndex,
                items: items,
                autoplay: false
            )
        }
    }
    
    return Example()
}
