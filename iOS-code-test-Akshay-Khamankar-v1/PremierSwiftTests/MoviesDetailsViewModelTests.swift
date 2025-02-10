//
//  Untitled.swift
//  PremierSwift
//
//  Created by Akshay Khamankar on 10/02/25.
//  Copyright © 2025 Deliveroo. All rights reserved.
//

import XCTest
@testable import PremierSwift
import XCTest
@testable import PremierSwift

final class MoviesDetailsViewModelTests: XCTestCase {

    var viewModel: MoviesDetailsViewModel!
    var mockAPIManager: MockAPIManager!
    
    let testMovie = Movie(
        id: 1,
        title: "Test Movie",
        overview: "This is a test movie.",
        posterPath: "test_poster.jpg",
        voteAverage: 7.5
    )

    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        viewModel = MoviesDetailsViewModel(movie: testMovie, apiManager: mockAPIManager)
    }

    override func tearDown() {
        viewModel = nil
        mockAPIManager = nil
        super.tearDown()
    }

    // "" Test Initial State
    func testInitialStateIsLoading() {
        XCTAssertEqual(viewModel.state, .loading(testMovie), "❌ Initial state should be .loading with the movie")
    }

    // "" Test Fetch Data Calls API
    func testFetchDataUpdatesStateOnSuccess() {
        // Given: Mock API responses
        let mockMovieDetails = MovieDetails(
            title: "Movie Title",
            overview: "Movie overview",
            backdropPath: "backdrop.jpg",
            tagline: "This is a tagline"
        )
        
        let mockSimilarMovies = SimilarMovieDetails(
            title: "Similar Movie List",
            page: 1,
            results: [
                SimilarMovieDetailsResult(
                    id: 101,
                    posterPath: "poster1.jpg", releaseDate: "2024-01-01", title: "Similar 1",
                    voteAverage: 8.5
                ),
                SimilarMovieDetailsResult(
                    id: 102,
                    posterPath: "poster2.jpg", releaseDate: "2023-12-15", title: "Similar 2",
                    voteAverage: 7.9
                )
            ],
            totalPages: 1,
            totalResults: 2
        )

        mockAPIManager.mockMovieDetails = mockMovieDetails
        mockAPIManager.mockSimilarMovies = mockSimilarMovies
        
        let expectation = self.expectation(description: "State should be updated to .loaded")

        // When: Fetching data
        viewModel.updatedState = {
            if case .loaded(let details, let similar) = self.viewModel.state {
                XCTAssertEqual(details.title, mockMovieDetails.title, "❌ Movie title should match fetched data")
                XCTAssertEqual((similar as! SimilarMovieDetails).results?.count, mockSimilarMovies.results?.count, "❌ Similar movies count should match")
                expectation.fulfill()
            }
        }
        
        viewModel.fetchData()
        waitForExpectations(timeout: 1)
    }

    // "" Test API Failure Handling
    func testFetchDataHandlesErrorCorrectly() {
        // Given: API should return error
        mockAPIManager.shouldReturnError = true
        
        let expectation = self.expectation(description: "State should be updated to .error")
        
        viewModel.updatedState = {
            if case .error = self.viewModel.state {
                expectation.fulfill()
            }
        }

        // When: Fetching data
        viewModel.fetchData()
        waitForExpectations(timeout: 1)
    }

    // "" Test Partial Data Handling (Only Movie Details)
    func testFetchDataHandlesPartialData() {
        // Given: Movie details available, but no similar movies
        let mockMovieDetails = MovieDetails(
            title: "Movie Title",
            overview: "Movie overview",
            backdropPath: "backdrop.jpg",
            tagline: "This is a tagline"
        )
        
        mockAPIManager.mockMovieDetails = mockMovieDetails
        mockAPIManager.mockSimilarMovies = nil // No similar movies

        let expectation = self.expectation(description: "State should be updated to .error")

        viewModel.updatedState = {
            if case .error = self.viewModel.state {
                expectation.fulfill()
            }
        }

        // When: Fetching data
        viewModel.fetchData()
        waitForExpectations(timeout: 1)
    }

    // "" Test Partial Data Handling (Only Similar Movies)
    func testFetchDataHandlesPartialSimilarMovies() {
        // Given: Similar movies available, but no movie details
        let mockSimilarMovies = SimilarMovieDetails(
            title: "Similar Movie List",
            page: 1,
            results: [
                SimilarMovieDetailsResult(
                    id: 101,
                    posterPath: "poster1.jpg", releaseDate: "2024-01-01", title: "Similar 1",
                    voteAverage: 8.5
                )
            ],
            totalPages: 1,
            totalResults: 1
        )

        mockAPIManager.mockMovieDetails = nil
        mockAPIManager.mockSimilarMovies = mockSimilarMovies

        let expectation = self.expectation(description: "State should be updated to .error")

        viewModel.updatedState = {
            if case .error = self.viewModel.state {
                expectation.fulfill()
            }
        }

        // When: Fetching data
        viewModel.fetchData()
        waitForExpectations(timeout: 1)
    }
}
