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
    
    // MARK: - Life Cicle
    
    var body: some View {
        Rectangle()
            .fill(.clear)
            .overlay {
                WebImage(url: url)
                    .resizable()
                    .indicator(.activity(style: .circular))
                    .aspectRatio(contentMode: .fill)
            }
            .clipped()
    }
}

#Preview {
    ImageView(url: episodes[0].imageURL)
}
