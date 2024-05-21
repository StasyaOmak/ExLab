//
//  CachedAsyncImage.swift
//  ExLabTest
//
//  Created by Anastasiya Omak on 21/05/2024.
//

import SwiftUI

struct CachedAsyncImage: View {
    @StateObject private var loader: AsyncImageLoader
    private let url: URL?

    init(url: URL?) {
        _loader = StateObject(wrappedValue: AsyncImageLoader(url: url))
        self.url = url
    }

    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            ProgressView()
        }
    }
}

