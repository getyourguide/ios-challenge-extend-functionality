//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import Combine
import XCTest
@testable import GYGChallenge

final class ReviewsRepositoryMock: ReviewsRepositoryProtocol {
    private(set) var lastActivityID: Int?
    private(set) var lastOffset: Int?
    private(set) var fetchReviewsCallsCount = 0

    var stub: AnyPublisher<[Reviews.Review], ReviewsDomainError> = Just([Fixture.makeReview()])
        .setFailureType(to: ReviewsDomainError.self)
        .eraseToAnyPublisher()

    func fetchReviews(
        activityID: Int,
        offset: Int
    ) -> AnyPublisher<[Reviews.Review], ReviewsDomainError> {
        fetchReviewsCallsCount += 1
        lastActivityID = activityID
        lastOffset = offset

        return stub
    }
}

final class ReviewViewModelTests: XCTestCase {
    private var sut: ReviewsViewModel!
    private var repositoryMock: ReviewsRepositoryMock!
    private var disposeBag: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()

        disposeBag = Set<AnyCancellable>()
        repositoryMock = ReviewsRepositoryMock()
        sut = ReviewsViewModel(
            activityID: 99,
            reviewsRepository: repositoryMock
        )
    }

    override func tearDownWithError() throws {
        repositoryMock = nil
        disposeBag = nil
        sut = nil

        try super.tearDownWithError()
    }

    func testViewLoadedWhenReviewsAreFetchedWithSuccess() {
        repositoryMock.stub = Just(
            [
                Fixture.makeReview(),
                Fixture.makeReview(enjoyment: "zupá")
            ]
        )
        .setFailureType(to: ReviewsDomainError.self)
        .eraseToAnyPublisher()

        var receivedViewStates: [ReviewsViewState] = []

        sut.viewState
            .sink { viewState in
                receivedViewStates.append(viewState)
            }
            .store(in: &disposeBag)

        sut.send(.viewLoaded)

        XCTAssertEqual(
            receivedViewStates,
            [
                .idle,
                .loaded(
                    reviews: [
                        Fixture.makeReviewViewModel(),
                        Fixture.makeReviewViewModel(title: "zupá")
                    ]
                )
            ]
        )
    }
}
