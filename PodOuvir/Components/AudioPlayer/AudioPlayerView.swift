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
    
    // MARK: - Public Variables
    
    let media: any AudioPlayer.Media
    
    var body: some View {
        VStack {
            Button("Play") {
                audioPlayer.play()
            }
            Button("Pause") {
                audioPlayer.pause()
            }
            Button("Stop") {
                audioPlayer.stop()
            }
            Text("Current Time: \(audioPlayer.currentTime.hourMinuteSecond)")
            Text("Total Time: \(audioPlayer.totalTime.hourMinuteSecond)")
        }.task {
            try? await audioPlayer.load(media: media)
        }.onDisappear {
            audioPlayer.stop()
        }
    }
}

#Preview {
    AudioPlayerView(media: AudioPlayer.Audio(url: podcastURL))
}
