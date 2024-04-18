//
//  AudioPlayerCover.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import SwiftUI
import SnapPagerCarousel

struct AudioPlayerCover: View {
    
    // MARK: - Public Variables
    
    @State var artworks: [URL]
    @Binding var selectedItem: URL?
    @Binding var currentIndex: Int
    
    var body: some View {
        SnapPager(
            items: $artworks,
            selection: $selectedItem,
            currentIndex: $currentIndex,
            edgesOverlap: 22,
            itemsMargin: 8
        ) { index, item in
            Rectangle()
                .overlay {
                    AsyncImage(url: item) { phase in
                        phase.image?.resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .clipped()
        }
    }
}

#Preview {
    struct Example:View {
        @State private var currentIndex = 0
        @State private var selectedItem: URL?
        @State private var artworks = [URL]()
        
        var body: some View {
            AudioPlayerCover(
                artworks: artworks,
                selectedItem: $selectedItem,
                currentIndex: $currentIndex
            ).onAppear {
                artworks = [
                    alanWakeSample,
                    donkeyKongSample,
                    zeldaTOTKSample
                ].compactMap { $0.artworkUrl }
            }
        }
    }
    
    return Example()
}
