//
//  AudioPlayerView.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 13/04/24.
//

import SwiftUI

struct AudioPlayerView<T: Media>: View {
    
    @Environment(AudioPlayer<T>.self) var audioPlayer
    
    // MARK: - Private Variables
    
    @State private var currentTime: Double = 0
    @State private var isPlaying = false
    @State private var selection: T?
    
    private var currentItem: T {
        items[currentIndex]
    }
    
    // MARK: - Public Variables
    
    @State var currentIndex = 0
    @State var items: [T]
    
    let autoplay: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            AudioPlayerCover<T>(
                items: $items,
                selection: $selection,
                currentIndex: $currentIndex
            )
            
            VStack(spacing: 16) {
                AudioPlayerTitle(
                    title: currentItem.title,
                    artist: currentItem.artist
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
                ).onChange(of: audioPlayer.isPlaying, initial: true) { _, newValue in
                    isPlaying = newValue
                }.onChange(of: audioPlayer.currentItem) { _, newValue in
                    selection = newValue
                }
            }
            .padding(.horizontal, 32)
            .onChange(of: currentItem, initial: true) { _, newValue in
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
        @State var items: [Item] = [
            zeldaTOTKSample,
            donkeyKongSample,
            alanWakeSample
        ]
        
        var body: some View {
            AudioPlayerView<Item>(
                items: items,
                autoplay: false
            )
        }
    }
    
    return Example()
        .environment(AudioPlayer<Item>())
}
