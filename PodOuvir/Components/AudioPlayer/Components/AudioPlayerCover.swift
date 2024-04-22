//
//  AudioPlayerCover.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct AudioPlayerCover<T: Media>: View {
    
    // MARK: - Public Variables
    
    @State var items: [T]
    @Binding var selection: T
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(items, id: \.self) { item in
                Rectangle()
                    .overlay {
                        WebImage(url: item.artworkURL)
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.26))
                            .aspectRatio(contentMode: .fill)
                    }
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()
            }
            .padding(.horizontal)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

#Preview {
    struct Example:View {
        @State private var items = episodes
        @State private var selection = episodes[0]
        
        var body: some View {
            AudioPlayerCover<Episode>(
                items: items,
                selection: $selection
            )
        }
    }
    
    return Example()
}
