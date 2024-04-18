//
//  AudioPlayerCover.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import SwiftUI
import SnapPagerCarousel

struct AudioPlayerCover<T: Media>: View {
    
    // MARK: - Public Variables
    
    @Binding var items: [T]
    @Binding var selection: T?
    @Binding var currentIndex: Int
    
    var body: some View {
        SnapPager(
            items: $items,
            selection: $selection,
            currentIndex: $currentIndex,
            edgesOverlap: 22,
            itemsMargin: 8
        ) { index, item in
            Rectangle()
                .overlay {
                    AsyncImage(url: item.artworkUrl) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView().progressViewStyle(.circular)
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
        @State private var selectedItem: Item?
        @State private var artworks = [Item]()
        
        var body: some View {
            AudioPlayerCover<Item>(
                items: $artworks,
                selection: $selectedItem,
                currentIndex: $currentIndex
            ).onAppear {
                artworks = [
                    alanWakeSample,
                    donkeyKongSample,
                    zeldaTOTKSample
                ]
            }
        }
    }
    
    return Example()
}
