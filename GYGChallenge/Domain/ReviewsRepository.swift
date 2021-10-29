//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import Combine

enum ReviewsDomainError: Error {
    case offline
    case general
}

private extension ReviewsDomainError {
    init(from error: ReviewsNetworkError) {
        switch error {
        case .offline:
            self = .offline
        case .generalError, .unableToBuildRequest:
            self = .general
        }
    }
}

protocol ReviewsRepositoryProtocol {
    func fetchReviews(
        activityID: Int,
        offset: Int
    ) -> AnyPublisher<[Reviews.Review], ReviewsDomainError>
}

final class ReviewsRepository: ReviewsRepositoryProtocol {
    private let networkClient: ReviewsNetworkClientProtocol

    init(networkClient: ReviewsNetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchReviews(
        activityID: Int,
        offset: Int
    ) -> AnyPublisher<[Reviews.Review], ReviewsDomainError> {
        networkClient.fetchReviews(activityID: activityID, offset: offset)
            .map { reviews in
                reviews.map(Reviews.Review.init(from:))
            }
            .mapError(ReviewsDomainError.init(from:))
            .eraseToAnyPublisher()
    }
}
