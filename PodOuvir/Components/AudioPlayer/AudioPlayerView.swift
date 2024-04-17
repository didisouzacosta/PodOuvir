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
    
    let media: AudioPlayer.Media
    let autoplay: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Spacer()
                
                VStack {
                    Text(media.title ?? "...")
                        .font(.title)
                    Text(media.artist ?? "...")
                        .font(.title3)
                        .foregroundStyle(.gray)
                }
                
                HStack {
                    Text(audioPlayer.currentTime.minuteSecond)
                    Spacer()
                    Text(audioPlayer.totalTime.minuteSecond)
                }
                
                HStack(spacing: 16) {
                    Button {
                        audioPlayer.backward()
                    } label: {
                        Image(systemName: "gobackward.10")
                            .font(.system(size: 32))
                    }
                    
                    Button {
                        audioPlayer.playPause()
                    } label: {
                        Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 62))
                    }
                    
                    Button {
                        audioPlayer.forward()
                    } label: {
                        Image(systemName: "goforward.10")
                            .font(.system(size: 32))
                    }
                }
            }.padding()
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
        try await audioPlayer.load(media: media)
        
        guard autoplay else { return }
        guard media.url != audioPlayer.currentItem?.url else { return }
        
        audioPlayer.play()
    }
}

#Preview {
    AudioPlayerView(
        media: fakePodcast,
        autoplay: false
    )
}
