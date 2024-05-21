//
//  PhotoView.swift
//  ExLabTest
//
//  Created by Anastasiya Omak on 19/05/2024.
//

import SwiftUI

struct PhotoView: View {
    @State private var photos: [Photo] = []
    @State private var searchTerm = ""
    @State private var isLoading = false
    @State private var page = 1

    var filteredPhotos: [Photo] {
        guard !searchTerm.isEmpty else { return photos }
        return photos.filter { $0.title.localizedStandardContains(searchTerm) }
    }

    private let columns = [
        GridItem(.adaptive(minimum: 300))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredPhotos) { photo in
                        NavigationLink(destination: FullScreenImageView(url: URL(string: photo.url))) {
                            VStack {
                                CachedAsyncImage(url: URL(string: photo.url))
                                    .frame(minWidth: 150, maxWidth: .infinity, minHeight: 150, maxHeight: 300)
                                    .clipped()
                                    .overlay(
                                        Text(photo.title)
                                            .frame(width: 150, height: 50)
                                            .foregroundColor(.white)
                                            .padding()
                                            .minimumScaleFactor(0.1)
                                            .background(Color.black.opacity(0.4))
                                            .cornerRadius(8)
                                            .padding(2),
                                        alignment: .bottom
                                    )
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal, 4)
                        }
                        .onAppear {
                            if shouldLoadMoreData(photo: photo) {
                                loadMoreData()
                            }
                        }
                    }
                }
                .padding()
                if isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .refreshable {
                await fetchPhotos()
            }
            .onAppear {
                Task {
                    await fetchPhotos()
                }
            }
            .navigationBarTitle("Photos")
            .searchable(text: $searchTerm, prompt: "Search photos")
        }
    }

    private func fetchPhotos() async {
        guard !isLoading else { return }
        isLoading = true
        do {
            let url = URL(string: "https://jsonplaceholder.typicode.com/photos?_page=\(page)&_limit=10")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let newPhotos = try JSONDecoder().decode([Photo].self, from: data)
            photos.append(contentsOf: newPhotos)
            page += 1
        } catch {
            print("\(error)")
        }
        isLoading = false
    }

    private func shouldLoadMoreData(photo: Photo) -> Bool {
        guard let lastPhoto = filteredPhotos.last else { return false }
        return photo.id == lastPhoto.id
    }

    private func loadMoreData() {
        Task {
            await fetchPhotos()
        }
    }
}

#Preview {
    PhotoView()
}
