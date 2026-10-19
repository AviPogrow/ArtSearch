//
//  ArtSearchTests.swift
//  ArtSearchTests
//
//  Created by Avi Pogrow on 10/16/26.
//

import XCTest
@testable import ArtSearch

@MainActor
final class ArtSearchTests: XCTestCase {

    func testSearchShowsResults() async {
        // Arrange: set up the fake and the view model
        let lilies = Artwork(id: 1, title: "Water Lilies", artist: "Claude Monet")
        let fake = FakeArtworkService(ids: [1], artworks: [1: lilies])
        let viewModel = SearchViewModel(service: fake)

        // Act: do what the user would do
        viewModel.send(.queryChanged("monet"))
        await viewModel.sendAndWait(.searchSubmitted)

        // Assert: check the whole screen in one comparison
        
        XCTAssertEqual(viewModel.state, SearchState(query: "monet", phase: .loaded([lilies])))
    }
    
    func testSearchWithNoMatchesShowsEmpty() async {
        let fake = FakeArtworkService(ids: [])
        let viewModel = SearchViewModel(service: fake)

        viewModel.send(.queryChanged("zzzz"))

        await viewModel.sendAndWait(.searchSubmitted)

        XCTAssertEqual(viewModel.state, SearchState(query: "zzzz", phase: .empty))
    }
    
    func testSearchFailureShowsError() async {
        let fake = FakeArtworkService(shouldFail: true)
        let viewModel = SearchViewModel(service: fake)

        viewModel.send(.queryChanged("monet"))
        await viewModel.sendAndWait(.searchSubmitted)

        XCTAssertEqual(viewModel.state, SearchState(query: "monet", phase: .failed("Search failed. Try again.")))
    }
}
