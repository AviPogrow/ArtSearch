//
//  ContentView.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/16/26.
//
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()   // the view creates it, so it has an =

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let message = viewModel.errorMessage {
                    Text(message)
                } else {
                    List(viewModel.artworks) { ArtworkRow(artwork: $0) }
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
