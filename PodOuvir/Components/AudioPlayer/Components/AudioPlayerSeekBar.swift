//
//  AudioPlayerSeekBar.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import SwiftUI

struct AudioPlayerSeekBar: View {
    @Binding var currentTime: Double
    
    let totalTime: Double
    let playHandler: (Double) -> Void
    let stopHandler: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(currentTime.minuteSecond)
                Spacer()
                Text(totalTime.minuteSecond)
            }
            Slider(
                value: $currentTime,
                in: 0...totalTime
            ) { isEditing in
                if isEditing {
                    stopHandler()
                } else {
                    playHandler(currentTime)
                }
            }
        }
    }
}

#Preview {
    struct Example: View {
        @State var currentTime: Double = 0
        
        var body: some View {
            AudioPlayerSeekBar(
                currentTime: $currentTime,
                totalTime: 100,
                playHandler: { time in },
                stopHandler: {}
            )
        }
    }
    
    return Example()
}
