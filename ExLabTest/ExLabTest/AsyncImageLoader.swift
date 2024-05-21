//
//  sample.swift
//  ExLabTest
//
//  Created by Anastasiya Omak on 20/05/2024.
//

import Foundation
import UIKit
import SwiftUI

class AsyncImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var url: URL?
    private var cache = URLCache.shared

    init(url: URL?) {
        self.url = url
        loadImage()
    }

    private func loadImage() {
        guard let url = url else { return }

        let request = URLRequest(url: url)
        if let cachedResponse = cache.cachedResponse(for: request) {
            if let cachedImage = UIImage(data: cachedResponse.data) {
                print("Loaded image from cache: \(url)")
                self.image = cachedImage
                return
            }
        }

        print("Loading image from network: \(url)")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let image = UIImage(data: data) {
                let cachedData = CachedURLResponse(response: response, data: data)
                self.cache.storeCachedResponse(cachedData, for: request)
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                print("Failed to load image from network: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
}
