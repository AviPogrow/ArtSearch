//
//  ContentView.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/16/26.
//

import SwiftUI

struct SearchView: View {
    
    // computed property that has a custom
    // setter and getter connected to the view model
    // when read it returns viewModel.state.query
    // but when written it calls the send method
    // on the view model
    private var queryBinding: Binding<String> {
        Binding(
            get: { viewModel.state.query },
            set: { viewModel.send(.queryChanged($0)) }
        )
    }
    
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state.phase {
                case .idle:
            ContentUnavailableView("Search the Met", systemImage: "magnifyingglass")
                case .loading:
                    ProgressView()
                case .loaded(let artworks):
                    List(artworks) { ArtworkRow(artwork: $0) }
                        .refreshable { await viewModel.sendAndWait(.refreshPulled) }   // was viewModel.send(.refreshPulled)
                
                case .empty:
                    ContentUnavailableView.search(text: viewModel.state.query)
                case .failed(let message):
                    ContentUnavailableView("Search failed", systemImage: "exclamationmark.triangle",
                                           description: Text(message))
                }
            }
            .navigationTitle("Art Search")
            .searchable(text: queryBinding)
            .onSubmit(of: .search) { viewModel.send(.searchSubmitted) }
        }
    }
}

#Preview {
    SearchView()
}
