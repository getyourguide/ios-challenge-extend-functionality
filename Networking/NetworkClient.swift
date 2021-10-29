//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import Combine

public protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: URLSessionProtocol {}

public protocol NetworkClientProtocol {
    func run<Body: Decodable>(
        _ request: URLRequest,
        successDecoder: JSONDecoder,
        receiveOn completionQueue: DispatchQueue
    ) -> AnyPublisher<HTTPResponse<Body>, NetworkError>
}

public final class NetworkClient: NetworkClientProtocol {
    private let urlSession: URLSessionProtocol

    public init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    private static let validStatusCodes = Set(200..<300)

    public func run<Body: Decodable>(
        _ request: URLRequest,
        successDecoder: JSONDecoder,
        receiveOn completionQueue: DispatchQueue
    ) -> AnyPublisher<HTTPResponse<Body>, NetworkError> {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> HTTPResponse in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }

                let statusCode = httpResponse.statusCode
                guard Self.validStatusCodes.contains(statusCode) else {
                    throw NetworkError.unhandled(statusCode)
                }

                return HTTPResponse(
                    body: data,
                    decoder: successDecoder,
                    validStatusCode: Self.validStatusCodes,
                    statusCode: statusCode,
                    urlResponse: response
                )
            }
            .eraseToAnyPublisher()
            .mapError { error -> NetworkError in
                if let urlError = error as? URLError {
                    return .underlying(urlError)
                } else if let decodingError = error as? DecodingError {
                    return .decoding(decodingError)
                }
                return .unknown(error: error)
            }
            .receive(on: completionQueue)
            .eraseToAnyPublisher()
    }
}
