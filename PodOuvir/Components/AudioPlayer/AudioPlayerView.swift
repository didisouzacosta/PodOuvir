//
//  AudioPlayerView.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 13/04/24.
//

import SwiftUI

struct AudioPlayerView<T: Media>: View {
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Public Variables
    
    @State var items: [T]
    @Binding var selection: T?
    
    var autoplay: Bool
    
    // MARK: - Private Variables
    
    @State private var currentTime: Double = 0
    
    private let audioPlayer = AudioPlayer.shared
    
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
        if items.isEmpty {
            EmptyView()
        } else {
            VStack(spacing: 16) {
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                }
                
                Spacer()
                
                AudioPlayerCover(item: currentItem)
                
                Spacer()
                
                VStack(spacing: 16) {
                    AudioPlayerTitle(
                        title: currentItem.title,
                        author: currentItem.author
                    )
                    
                    AudioPlayerSeekBar(
                        currentTime: $currentTime,
                        duration: audioPlayer.duration
                    ) { time in
                        audioPlayer.seek(to: time)
                        audioPlayer.play()
                    } pauseHandler: {
                        audioPlayer.pause()
                    }
                    .disabled(audioPlayer.isLoading)
                    .onChange(of: audioPlayer.currentTime, initial: true) { _, newValue in
                        currentTime = newValue
                    }
                    
                    AudioPlayerControls(
                        isPlaying: audioPlayer.isPlaying,
                        isLoading: audioPlayer.isLoading,
                        playHandler: audioPlayer.play,
                        pauseHandler: audioPlayer.pause,
                        nextHandler: next,
                        previousHandler: previous,
                        hasPrevious: hasPrevious,
                        hasNext: hasNext
                    )
                    .onChange(of: currentItem, initial: true) { _, newValue in
                        Task {
                            try await audioPlayer.load(
                                newValue,
                                autoplay: autoplay
                            )
                        }
                        updateAudioPlayerControls()
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .onAppear {
                setupAudioPlayerHandlers()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupAudioPlayerHandlers() {
        audioPlayer.previousHandler = previous
        audioPlayer.nextHandler = next
    }
    
    private func updateAudioPlayerControls() {
        audioPlayer.hasPrevious = hasPrevious
        audioPlayer.hasNext = hasNext
    }
    
    private func previous() {
        selection = previousItem
    }
    
    private func next() {
        selection = nextItem
    }
    
}

#Preview {
    struct Example: View {
        @State var selection: Episode?
        
        var body: some View {
            AudioPlayerView(
                items: episodes,
                selection: $selection,
                autoplay: false
            )
        }
    }
    
    return Example()
}
