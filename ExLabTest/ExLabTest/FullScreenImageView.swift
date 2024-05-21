//
//  FullScreenImageView.swift
//  ExLabTest
//
//  Created by Anastasiya Omak on 21/05/2024.
//


import SwiftUI

struct FullScreenImageView: View {
    let url: URL?
    @StateObject private var loader: AsyncImageLoader

    init(url: URL?) {
        _loader = StateObject(wrappedValue: AsyncImageLoader(url: url))
        self.url = url
    }

    var body: some View {
        VStack {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}
