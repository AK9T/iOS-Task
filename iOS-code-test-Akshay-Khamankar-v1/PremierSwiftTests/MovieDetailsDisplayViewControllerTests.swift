//
//  Untitled.swift
//  PremierSwift
//
//  Created by Akshay Khamankar on 09/02/25.
//  Copyright © 2025 Deliveroo. All rights reserved.
//
@testable import PremierSwift
import XCTest
import UIKit
import XCTest
@testable import PremierSwift

final class MovieDetailsDisplayViewControllerTests: XCTestCase {

    // MARK: - Test: View Controller Initialization

    func testViewControllerInitialization() {
        // Given
        let movieDetails = MovieDetails(title: "Test Movie", overview: "Test Overview", backdropPath: "test_path", tagline: nil)
        let similarMovies = [
            SimilarMovieDetailsResult(posterPath: "poster1.jpg", releaseDate: "2022-01-01", title: "Similar 1", voteAverage: 7.5),
            SimilarMovieDetailsResult(posterPath: "poster2.jpg", releaseDate: "2022-02-02", title: "Similar 2", voteAverage: 8.2)
        ]
        
        // When
        let vc = MovieDetailsDisplayViewController(movieDetails: movieDetails, similarMovies: similarMovies)
        
        // Then
        XCTAssertNotNil(vc)
        XCTAssertEqual(vc.movieDetails.title, "Test Movie")
        XCTAssertEqual(vc.movieDetails.overview, "Test Overview")
    }

    // MARK: - Test: Table View Data Source

    func testTableViewNumberOfRows() {
        // Given
        let movieDetails = MovieDetails(title: "Test Movie", overview: "Test Overview", backdropPath: "test_path", tagline: nil)
        let similarMovies: [SimilarMovieDetailsResult] = []
        let vc = MovieDetailsDisplayViewController(movieDetails: movieDetails, similarMovies: similarMovies)
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        let tableView = vc.exposedTableView
        XCTAssertNotNil(tableView)

        // Expected rows: Image, Title, Overview, Cards
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 4)
    }

    func testTableViewCellTypes() {
        // Given
        let movieDetails = MovieDetails(title: "Test Movie", overview: "Test Overview", backdropPath: "test_path", tagline: nil)
        let similarMovies: [SimilarMovieDetailsResult] = []
        let vc = MovieDetailsDisplayViewController(movieDetails: movieDetails, similarMovies: similarMovies)

        // When
        vc.loadViewIfNeeded()
        let tableView = vc.exposedTableView

        // Then
        let imageCell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(imageCell is MovieImageTableViewCell)

        let titleCell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        XCTAssertTrue(titleCell is MovieTitleTableViewCell)

        let overviewCell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0))
        XCTAssertTrue(overviewCell is MovieOverviewTableViewCell)

        let cardsCell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 3, section: 0))
        XCTAssertTrue(cardsCell is MovieCardsTableViewCell)
    }

    
    func testMovieImageTableViewCell() {
        // Given
        let cell = MovieImageTableViewCell(style: .default, reuseIdentifier: MovieImageTableViewCell.reuseIdentifier)
        let testBackdrop = "test_backdrop.jpg"

        // When
        cell.configure(with: testBackdrop)

        // "" Wait for UI updates
        RunLoop.current.run(until: Date() + 0.2)

        // Debug: Check if `backdropImageView` exists
        let mirror = Mirror(reflecting: cell)
        guard let backdropImageView = mirror.descendant("backdropImageView") as? UIImageView else {
            XCTFail("❌ backdropImageView not found in MovieImageTableViewCell")
            return
        }

        print(""" backdropImageView found: \(backdropImageView)")

        // Then: Check if image is set
        XCTAssertNotNil(backdropImageView.image, "❌ backdropImageView.image is nil even after calling configure")

        // Debug final check
        if backdropImageView.image == nil {
            print("❌ Test failed: Image still nil after configure!")
        } else {
            print(""" Test passed: Image is set correctly.")
        }
    }

    // MARK: - Test: Movie Title Table View Cell

    func testMovieTitleTableViewCell() {
        // Given
        let cell = MovieTitleTableViewCell(style: .default, reuseIdentifier: MovieTitleTableViewCell.reuseIdentifier)
        let testTitle = "Unit Test Title"

        // When
        cell.configure(with: testTitle)

        // Then
        let mirror = Mirror(reflecting: cell)
        if let titleLabel = mirror.descendant("titleLabel") as? UILabel {
            XCTAssertEqual(titleLabel.text, testTitle)
        } else {
            XCTFail("Title label not found")
        }
    }

    // MARK: - Test: Movie Overview Table View Cell

    func testMovieOverviewTableViewCell() {
        // Given
        let cell = MovieOverviewTableViewCell(style: .default, reuseIdentifier: MovieOverviewTableViewCell.reuseIdentifier)
        let testOverview = "Unit Test Overview"

        // When
        cell.configure(with: testOverview)

        // Then
        let mirror = Mirror(reflecting: cell)
        if let overviewLabel = mirror.descendant("overviewLabel") as? UILabel {
            XCTAssertEqual(overviewLabel.text, testOverview)
        } else {
            XCTFail("Overview label not found")
        }
    }

    // MARK: - Test: Movie Cards Table View Cell

    func testMovieCardsTableViewCell() {
        // Given
        let similarMovies = [
            SimilarMovieDetailsResult(posterPath: "poster1.jpg", releaseDate: "2021-01-01", title: "Movie 1", voteAverage: 8.0),
            SimilarMovieDetailsResult(posterPath: "poster2.jpg", releaseDate: "2021-02-01", title: "Movie 2", voteAverage: 7.5)
        ]
        let cell = MovieCardsTableViewCell(style: .default, reuseIdentifier: MovieCardsTableViewCell.reuseIdentifier)

        // When
        cell.configure(similarMovies: similarMovies)
        cell.layoutIfNeeded() // Ensure layout has occurred

        // "" Use the `exposedCollectionView` instead of `value(forKey:)`
        let collectionView = cell.exposedCollectionView

        // Then
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), similarMovies.count)
    }


    // MARK: - Test: Red Card Collection View Cell
    func testRedCardCollectionViewCell() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for UI updates")
        let cell = RedCardCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 144, height: 340))
        let rating = 8.54
        let title = "Card Title"
        let description = "Card Description"
        let image = "cardImage.jpg"
        let starImage = UIImage(systemName: "star.fill")!  // Use system image to ensure it exists

        // When
        cell.configure(rating: rating, title: title, description: description, image: image, starImage: starImage)

        // "" Use `RunLoop` to prevent premature test exit
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let mirror = Mirror(reflecting: cell)
            if let titleLabel = mirror.descendant("titleLabel") as? UILabel,
               let descriptionLabel = mirror.descendant("descriptionLabel") as? UILabel,
               let ratingLabel = mirror.descendant("ratingLabel") as? UILabel,
               let posterImageView = mirror.descendant("posterImageView") as? UIImageView,
               let starImageView = mirror.descendant("starImageView") as? UIImageView {

                XCTAssertEqual(titleLabel.text, title, "❌ titleLabel.text mismatch")
                XCTAssertEqual(descriptionLabel.text, description, "❌ descriptionLabel.text mismatch")
                XCTAssertEqual(ratingLabel.text, "\(rating.roundedToOneDecimalPlace)", "❌ ratingLabel.text mismatch")
                XCTAssertNotNil(posterImageView.image, "❌ posterImageView.image is still nil after configure")
                XCTAssertEqual(starImageView.image, starImage, "❌ starImageView.image mismatch")
            } else {
                XCTFail("❌ One or more UI components not found in RedCardCollectionViewCell")
            }

            expectation.fulfill() // "" Mark expectation as fulfilled
        }

        // "" Ensure test does not exit before `asyncAfter` runs
        wait(for: [expectation], timeout: 2.0)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.2)) // Prevents premature exit
    }



}
