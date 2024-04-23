//
//  AudioPlayerCover.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 18/04/24.
//

import SwiftUI
import SDWebImageSwiftUI
import Foundation

protocol Cover: Hashable, Identifiable {
    var midiaURL: URL { get }
}

struct AudioPlayerCover<T: Cover>: View {
    
    // MARK: - Public Variables
    
    @State var items: [T]
    @Binding var currentIndex: Int
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<items.count, id: \.self) { index in
                Rectangle()
                    .overlay {
                        WebImage(url: items[index].midiaURL)
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
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    struct Example:View {
        @State private var items = episodes
        @State private var currentIndex = 0
        
        var body: some View {
            AudioPlayerCover(
                items: items,
                currentIndex: $currentIndex
            )
        }
    }
    
    return Example()
}
