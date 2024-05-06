//
//  ImageView.swift
//  PodOuvir
//
//  Created by ProDoctor on 27/04/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    
    typealias Handler = ((UIImage?) -> Void)
    
    // MARK: - Public Variables
    
    let url: URL
    
    var handler: Handler?
    
    // MARK: - Life Cicle
    
    var body: some View {
        WebImage(url: url) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .onSuccess { image, _, _ in
            handler?(image)
        }
    }
}

#Preview {
    struct Example: View {
        @State private var image: UIImage?
        
        var body: some View {
            ImageView(url: episodes[0].imageURL)
        }
    }
    
    return Example()
}
