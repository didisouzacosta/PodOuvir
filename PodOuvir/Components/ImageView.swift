//
//  ImageView.swift
//  PodOuvir
//
//  Created by ProDoctor on 27/04/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    
    // MARK: - Public Variables
    
    let url: URL
    
    // MARK: - Private Variables
    
    @ObservedObject private var imageManager = ImageManager()
    
    // MARK: - Life Cicle
    
    var body: some View {
        Group {
            if let image = imageManager.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(.gray)
                    .overlay {
                        ProgressView()
                    }
            }
        }
        .onAppear {
            imageManager.load(url: url)
        }
        .onDisappear { imageManager.cancel() }
    }
}

#Preview {
    ImageView(url: episodes[0].imageURL)
}
