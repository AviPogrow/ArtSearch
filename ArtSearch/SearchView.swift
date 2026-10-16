//
//  ContentView.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/16/26.
//

import SwiftUI

struct SearchView: View {
    @State private var query = ""                       // input: stored

    private let artworks = [
        Artwork(id: 1, title: "Water Lilies", artist: "Claude Monet"),
        Artwork(id: 2, title: "Wheat Field with Cypresses", artist: "Vincent van Gogh"),
        Artwork(id: 3, title: "The Harvesters", artist: "Pieter Bruegel the Elder"),
        Artwork(id: 4, title: "Bridge over a Pond of Water Lilies", artist: "Claude Monet")
    ]

    private var filteredArtworks: [Artwork] {           // output: computed
        if query.isEmpty { return artworks }
        return artworks.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.artist.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredArtworks) { artwork in
                ArtworkRow(artwork: artwork)
            }
            .navigationTitle("Art Search")
            .searchable(text: $query)
        }
    }
}

#Preview {
    SearchView()
}
