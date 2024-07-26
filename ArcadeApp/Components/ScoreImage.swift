//
//  ScoreImage.swift
//  ArcadeApp
//
//  Created by Gabriel Garcia Millan on 25/7/24.
//

import SwiftUI

struct ScoreImage: View {
    var image: UIImage?
    
    var body: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ScoreImage()
}
