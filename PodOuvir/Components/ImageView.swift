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
    
    var loadedImageHandler: ((UIImage) -> Void)?
    
    // MARK: - Life Cicle
    
    var body: some View {
        WebImage(url: url) { image in
            image.resizable()
        } placeholder: {
            Rectangle().foregroundColor(.gray)
        }
        .onSuccess { image, data, cache in
            loadedImageHandler?(image)
        }
        .indicator(.activity)
    }
}

#Preview {
    ImageView(url: episodes[0].imageURL)
}
