//
//  AudioPlayerSeekBar.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import SwiftUI

struct AudioPlayerSeekBar: View {
    @Binding var currentTime: Double
    
    let duration: Double
    let playHandler: (Double) -> Void
    let pauseHandler: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(currentTime.hourMinuteSecond)
                Spacer()
                Text(duration.isZero ? "--:--" : duration.hourMinuteSecond)
            }
            
            Slider(
                value: $currentTime,
                in: 0...duration
            ) { isEditing in
                isEditing ? pauseHandler() : playHandler(currentTime)
            }
            .tint(.controls)
        }
    }
}

#Preview {
    struct Example: View {
        @State var currentTime: Double = 0
        
        var body: some View {
            AudioPlayerSeekBar(
                currentTime: $currentTime,
                duration: 100,
                playHandler: { time in },
                pauseHandler: {}
            )
        }
    }
    
    return Example()
}
