//
//  AudioPlayerControls.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import SwiftUI

struct AudioPlayerControls: View {
    
    typealias Handler = () -> Void
    
    let isPlaying: Bool
    let isLoading: Bool
    let playHandler: Handler
    let pauseHandler: Handler
    let nextHandler: Handler?
    let previousHandler: Handler?
    
    var hasPrevious = false
    var hasNext = false
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                previousHandler?()
            } label: {
                Image(systemName: "backward.fill")
                    .font(.system(size: 30))
                    .foregroundColor(hasPrevious ? .controls : .accentColor)
            }
            .disabled(!hasPrevious)
            
            Button {
                isPlaying ? pauseHandler() : playHandler()
            } label: {
                Circle()
                    .overlay {
                        if isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.controls)
                        }
                    }
                    .foregroundStyle(.fill)
                    .frame(width: 62)
                    .clipped()
            }
            .disabled(isLoading)
            
            Button {
                nextHandler?()
            } label: {
                Image(systemName: "forward.fill")
                    .font(.system(size: 30))
                    .foregroundColor(hasNext ? .controls : .accentColor)
            }
            .disabled(!hasNext)
        }
    }
}

#Preview {
    struct Example: View {
        @State var isPlaying = true
        @State var isLoading = false
        @State var hasPrevious = false
        @State var hasNext = true
        
        var body: some View {
            AudioPlayerControls(
                isPlaying: isPlaying,
                isLoading: isLoading,
                playHandler: {},
                pauseHandler: {},
                nextHandler: {},
                previousHandler: {},
                hasPrevious: hasPrevious,
                hasNext: hasNext
            )
        }
    }
    
    return Example()
}
