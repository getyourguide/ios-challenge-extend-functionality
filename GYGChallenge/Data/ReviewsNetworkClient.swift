//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import Combine
import Networking

enum ReviewsNetworkError: Error {
    case offline
    case generalError
    case unableToBuildRequest
}

private extension ReviewsNetworkError {
    init(from error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .noInternet:
                self = .offline
            case .noData,
                    .timeout,
                    .cancelled,
                    .notFound,
                    .decoding,
                    .underlying,
                    .unknown,
                    .invalidResponse,
                    .unhandled:
                self = .generalError
            }
        } else {
            self = .generalError
        }
    }
}

protocol ReviewsNetworkClientProtocol {
    func fetchReviews(
        activityID: Int,
        offset: Int
    ) -> AnyPublisher<[ReviewsResponse.Review], ReviewsNetworkError>
}

final class ReviewsNetworkClient: ReviewsNetworkClientProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchReviews(
        activityID: Int,
        offset: Int
    ) -> AnyPublisher<[ReviewsResponse.Review], ReviewsNetworkError> {
        guard let request = makeReviewsRequest(activityID: activityID, offset: offset) else {
            return Fail(error: .unableToBuildRequest)
                .eraseToAnyPublisher()
        }

        return networkClient.run(
            request,
            successDecoder: .iso8601JSONDecoder,
            receiveOn: .main
        )
        .tryMap { (response: HTTPResponse<ReviewsResponse>) -> [ReviewsResponse.Review] in
            switch response.value {
            case let .success(body):
                return body.reviews
            case let .failure(error):
                throw error
            }
        }
        .mapError(ReviewsNetworkError.init(from:))
        .eraseToAnyPublisher()
    }
}

private func makeReviewsRequest(activityID: Int, offset: Int) -> URLRequest? {
    var urlComponents = URLComponents()
    urlComponents.host = "travelers-api.getyourguide.com"
    urlComponents.scheme = "https"
    urlComponents.path = "/activities/\(activityID)/reviews"
    urlComponents.queryItems = [
        URLQueryItem(name: "offset", value: String(offset))
    ]
    guard let url = urlComponents.url else {
        return nil
    }

    return URLRequest(url: url)
}
