//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

public enum NetworkError: Error {
    case cancelled
    case noData
    case noInternet
    case notFound
    case timeout
    case decoding(DecodingError)
    case underlying(_ error: URLError)
    case unknown(error: Error)
    case invalidResponse
    case unhandled(_ statusCode: Int)
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.cancelled, .cancelled),
            (.noData, .noData),
            (.noInternet, .noInternet),
            (.notFound, .notFound),
            (.timeout, .timeout),
            (.invalidResponse, .invalidResponse):
            return true
        case let (.unhandled(lhsStatusCode), .unhandled(rhsStatusCode)):
            return lhsStatusCode == rhsStatusCode
        case let (.underlying(lhsURLError), .underlying(rhsURLError)):
            return lhsURLError as NSError == rhsURLError as NSError
        case let (.decoding(lhsError), .decoding(rhsError)):
            return lhsError as NSError == rhsError as NSError
        case let (.unknown(lhsError), .unknown(rhsError)):
            return lhsError as NSError == rhsError as NSError
        default:
            return false
        }
    }
}
