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
    var imageURL: URL { get }
}

struct AudioPlayerCover<T: Cover>: View {
    
    // MARK: - Public Variables
    
    @State var items: [T]
    @Binding var currentIndex: Int
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<items.count, id: \.self) { index in
                WebImage(url: items[index].imageURL)
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
        }
//        .tabViewStyle(.page(indexDisplayMode: .always))
        .tabViewStyle(.page)
    }
}

#Preview {
    struct Example:View {
        @State private var items = episodes
        @State private var currentIndex = 0
        
        var body: some View {
            AudioPlayerCover<Episode>(
                items: items,
                currentIndex: $currentIndex
            )
        }
    }
    
    return Example()
}
