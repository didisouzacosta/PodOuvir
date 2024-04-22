//
//  AudioPlayerView.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 13/04/24.
//

import SwiftUI

struct AudioPlayerView<T: Media>: View {
    
    // MARK: - Public Variables
    
    @State var items: [T]
    @State var selection: T?
    
    var autoplay: Bool
    
    // MARK: - Private Variables
    
    private let audioPlayer = AudioPlayer.shared
    
    @State private var currentTime: Double = 0
    @State private var isPlaying = false
    
    private var currentItem: T {
        selection ?? items[0]
    }
    
    private var currentIndex: Int {
        items.firstIndex(of: currentItem) ?? 0
    }
    
    private var previousItem: T? {
        items[safe: currentIndex - 1]
    }
    
    private var nextItem: T? {
        items[safe: currentIndex + 1]
    }
    
    private var hasPrevious: Bool {
        previousItem != nil
    }
    
    private var hasNext: Bool {
        nextItem != nil
    }
    
    // MARK: - Life Cicle
    
    var body: some View {
        let bindableCurrentItem = Binding {
            currentItem
        } set: { value in
            selection = value
        }
        
        VStack(spacing: 16) {
            Spacer()
            
            AudioPlayerCover<T>(
                items: items,
                selection: bindableCurrentItem
            )
            
            VStack(spacing: 16) {
                AudioPlayerTitle(
                    episode: currentItem.episode,
                    title: currentItem.title,
                    artist: currentItem.artist
                )
                
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
                    isPlaying: isPlaying,
                    hasPrevious: hasPrevious,
                    hasNext: hasNext,
                    playHandler: audioPlayer.play,
                    pauseHandler: audioPlayer.pause,
                    nextHandler: next,
                    previousHandler: previous
                )
            }
            .padding(.horizontal, 32)
            .onChange(of: audioPlayer.isPlaying, initial: true) { _, newValue in
                isPlaying = newValue
            }
            .onChange(of: currentItem, initial: true) { _, newValue in
                Task {
                    try? await prepare(media: newValue)
                    guard autoplay else { return }
                    audioPlayer.play()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupAudioPlayer() async throws {
        audioPlayer.hasPrevious = hasPrevious
        audioPlayer.hasNext = hasNext
        audioPlayer.previousHandler = previous
        audioPlayer.nextHandler = next
    }
    
    private func prepare(media: T) async throws {
        try await audioPlayer.load(media: media)
    }
    
    private func previous() {
        guard let previousItem else { return }
        selection = previousItem
    }
    
    private func next() {
        guard let nextItem else { return }
        selection = nextItem
    }
    
}

#Preview {
    struct Example: View {
        @State var items = episodes
        
        var body: some View {
            AudioPlayerView<Episode>(
                items: items,
                selection: items.first,
                autoplay: false
            )
        }
    }
    
    return Example()
}
