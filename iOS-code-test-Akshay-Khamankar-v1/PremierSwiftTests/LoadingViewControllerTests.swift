//
//  LoadingViewControllerTests.swift
//  PremierSwift
//
//  Created by Akshay Khamankar on 10/02/25.
//  Copyright © 2025 Deliveroo. All rights reserved.
//

import XCTest
@testable import PremierSwift

final class LoadingViewControllerTests: XCTestCase {

    var sut: LoadingViewController! // System Under Test

    override func setUp() {
        super.setUp()
        sut = LoadingViewController()
        sut.loadViewIfNeeded() // Ensures the view is loaded before tests
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // "" Test View Loads Correctly
    func testViewLoadsCorrectly() {
        XCTAssertNotNil(sut.view, "❌ View should not be nil")
        XCTAssertEqual(sut.view.backgroundColor, .white, "❌ Background color should be white")
    }

    // "" Test Activity Indicator Exists
    func testActivityIndicatorExists() {
        XCTAssertNotNil(sut.activityIndicatorView, "❌ ActivityIndicatorView should be initialized")
        XCTAssertTrue(sut.activityIndicatorView.isDescendant(of: sut.view), "❌ ActivityIndicatorView should be added to the view hierarchy")
    }

    // "" Test Activity Indicator Starts Animating in viewWillAppear
    func testActivityIndicatorStartsAnimating() {
        // When
        sut.viewWillAppear(false)

        // Then
        XCTAssertTrue(sut.activityIndicatorView.isAnimating, "❌ Activity indicator should be animating in viewWillAppear")
    }

    // "" Test Activity Indicator Stops Animating in viewDidDisappear
    func testActivityIndicatorStopsAnimating() {
        // Given
        sut.viewWillAppear(false) // Start animating

        // When
        sut.viewDidDisappear(false)

        // Then
        XCTAssertFalse(sut.activityIndicatorView.isAnimating, "❌ Activity indicator should stop animating in viewDidDisappear")
    }
}
