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
    
    private var currentIndex: Int {
        guard let selection else { return 0 }
        return items.firstIndex(of: selection) ?? 0
    }
    
    private var currentItem: T {
        items[currentIndex]
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
        let bindingCurrentIndex = Binding {
            currentIndex
        } set: { value in
            selection = items[safe: value]
        }
        
        if items.isEmpty {
            EmptyView()
        } else {
            VStack(spacing: 16) {
                Spacer()
                
                AudioPlayerCover<T>(
                    items: items,
                    currentIndex: bindingCurrentIndex
                )
                
                VStack(spacing: 16) {
                    AudioPlayerTitle(
                        episode: currentItem.episode,
                        title: currentItem.title,
                        artist: currentItem.artist
                    )
                    
                    AudioPlayerSeekBar(
                        currentTime: $currentTime,
                        duration: audioPlayer.duration
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
                        playHandler: { audioPlayer.play() },
                        pauseHandler: { audioPlayer.pause() },
                        nextHandler: { next() },
                        previousHandler: { previous() }
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
                    
                    updateAudioPlayerControls()
                }
            }
            .onAppear {
                setupAudioPlayerHandlers()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupAudioPlayerHandlers() {
        audioPlayer.previousHandler = { previous() }
        audioPlayer.nextHandler = { next() }
    }
    
    private func updateAudioPlayerControls() {
        audioPlayer.hasPrevious = hasPrevious
        audioPlayer.hasNext = hasNext
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
        @State var selection = episodes[1]
        
        var body: some View {
            AudioPlayerView<Episode>(
                items: items,
                selection: selection,
                autoplay: false
            )
        }
    }
    
    return Example()
}
