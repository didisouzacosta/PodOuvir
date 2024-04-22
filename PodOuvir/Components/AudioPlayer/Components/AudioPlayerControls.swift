//
//  AudioPlayerControls.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import SwiftUI

struct AudioPlayerControls: View {
    
    typealias Handler = () -> Void
    
    @Binding var isPlaying: Bool
    
    var hasPrevious = false
    var hasNext = false
    
    let playHandler: Handler
    let pauseHandler: Handler
    let nextHandler: Handler?
    let previousHandler: Handler?
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                previousHandler?()
            } label: {
                Image(systemName: "backward.fill")
                    .font(.system(size: 30))
            }.disabled(!hasPrevious)
            
            Button {
                isPlaying ? pauseHandler() : playHandler()
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 62))
            }
            
            Button {
                nextHandler?()
            } label: {
                Image(systemName: "forward.fill")
                    .font(.system(size: 30))
            }.disabled(!hasNext)
        }
        .padding()
    }
}

#Preview {
    struct Example: View {
        @State var isPlaying = false
        @State var hasPrevious = false
        @State var hasNext = true
        
        var body: some View {
            AudioPlayerControls(
                isPlaying: $isPlaying,
                hasPrevious: hasPrevious,
                hasNext: hasNext,
                playHandler: {},
                pauseHandler: {},
                nextHandler: {},
                previousHandler: {}
            )
        }
    }
    
    return Example()
}
