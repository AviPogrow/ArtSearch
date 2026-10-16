//
//  ContentView.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/16/26.
//
import SwiftUI
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.phase {
                case .idle:
                    ContentUnavailableView("Search the Met", systemImage: "magnifyingglass")
                case .loading:
                    ProgressView()
                case .loaded(let artworks):
                    List(artworks) { ArtworkRow(artwork: $0) }
                        .refreshable { await viewModel.refresh() }   // await, never wrap in Task
                case .empty:
                    ContentUnavailableView.search(text: viewModel.query)
                case .failed(let message):
                    ContentUnavailableView("Search failed", systemImage: "exclamationmark.triangle",
                                           description: Text(message))
                }
            }
            .navigationTitle("Art Search")
            .searchable(text: $viewModel.query)
            .onSubmit(of: .search) { viewModel.submit() }
        }
    }
}

#Preview {
    SearchView()
}
