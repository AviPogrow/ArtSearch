//
//  ContentView.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/16/26.
//
import SwiftUI

struct SearchView: View {
    @State private var query = ""
    @State private var artworks: [Artwork] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                } else if let errorMessage {
                    Text(errorMessage)
                } else {
                    List(artworks) { ArtworkRow(artwork: $0) }
                }
            }
            .navigationTitle("Art Search")
            .searchable(text: $query)
            .onSubmit(of: .search) {
                Task { await search() }
            }
        }
    }

    private func search() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            var components = URLComponents(string: "https://collectionapi.metmuseum.org/public/collection/v1.1/search")!
            components.queryItems = [
                URLQueryItem(name: "hasImages", value: "true"),
                URLQueryItem(name: "q", value: query)   // the Met requires q to be last
            ]
            let (data, _) = try await URLSession.shared.data(from: components.url!)
            let ids = try JSONDecoder().decode(SearchResponse.self, from: data).objectIDs ?? []

            var results: [Artwork] = []
            for id in ids.prefix(20) {
                let url = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(id)")!
                if let data = try? await URLSession.shared.data(from: url).0,
                   let artwork = try? JSONDecoder().decode(Artwork.self, from: data) {
                    results.append(artwork)
                }
            }
            artworks = results
        } catch {
            errorMessage = "Search failed. Try again."
        }
    }
}

#Preview {
    SearchView()
}
