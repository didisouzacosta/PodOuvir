//
//  AudioPlayerView.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 13/04/24.
//

import SwiftUI

struct AudioPlayerView: View {
    
    // MARK: - Private Variables
    
    private let audioPlayer = AudioPlayer.shared
    
    @State private var currentTime: Double = 0
    @State private var isPlaying = false
    
    // MARK: - Public Variables
    
    let media: AudioPlayer.Media
    let autoplay: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Spacer()
                
                AudioPlayerCover(artworkUrl: media.artworkUrl)
                
                Spacer()
                
                AudioPlayerTitle(
                    title: media.title,
                    artist: media.artist
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
                    isPlaying: $isPlaying,
                    playHandler: { audioPlayer.play() },
                    pauseHandler: { audioPlayer.pause() },
                    backwardHandler: { audioPlayer.backward() },
                    forwardHandler: { audioPlayer.forward() }
                ).onChange(of: audioPlayer.isPlaying) { _, newValue in
                    self.isPlaying = newValue
                }
            }
            .padding(32)
        }.onAppear {
            Task {
                do {
                    try await prepareMedia()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func prepareMedia() async throws {
        guard media.url != audioPlayer.currentItem?.url else { return }
        try await audioPlayer.load(media: media)
        guard autoplay else { return }
        audioPlayer.play()
    }
}

#Preview {
    AudioPlayerView(
        media: fakePodcast,
        autoplay: false
    )
}
