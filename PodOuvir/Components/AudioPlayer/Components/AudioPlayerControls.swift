//
//  AudioPlayerControls.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import SwiftUI

struct AudioPlayerControls: View {
    @Binding var isPlaying: Bool
    
    let playHandler: () -> Void
    let pauseHandler: () -> Void
    let backwardHandler: () -> Void
    let forwardHandler: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                backwardHandler()
            } label: {
                Image(systemName: "gobackward.10")
                    .font(.system(size: 32))
            }
            Button {
                isPlaying ? pauseHandler() : playHandler()
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 62))
            }
            Button {
                forwardHandler()
            } label: {
                Image(systemName: "goforward.10")
                    .font(.system(size: 32))
            }
        }
    }
}

#Preview {
    struct Example: View {
        @State var isPlaying = false
        
        var body: some View {
            AudioPlayerControls(
                isPlaying: $isPlaying,
                playHandler: {},
                pauseHandler: {},
                backwardHandler: {},
                forwardHandler: {}
            )
        }
    }
    
    return Example()
}
