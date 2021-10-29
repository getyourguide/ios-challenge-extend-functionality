//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

public struct HTTPResponse<Body: Decodable & Equatable>: Equatable {
    public enum Value: Equatable {
        case success(Body)
        case failure(NetworkError)
    }

    public let value: Value
    public let statusCode: Int
    public let urlResponse: URLResponse

    public var isSuccess: Bool {
        guard case .success = value else { return false }
        return true
    }

    init(
        body: Data,
        decoder: JSONDecoder,
        validStatusCode: Set<Int>,
        statusCode: Int,
        urlResponse: URLResponse
    ) {
        if validStatusCode.contains(statusCode) {
            do {
                let decodedValue = try decoder.decode(Body.self, from: body)
                value = .success(decodedValue)
            } catch {
                if let decodingError = error as? DecodingError {
                    value = .failure(.decoding(decodingError))
                } else {
                    value = .failure(.unknown(error: error))
                }
            }
        } else {
            value = .failure(.unhandled(statusCode))
        }

        self.statusCode = statusCode
        self.urlResponse = urlResponse
    }
}

extension HTTPResponse: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        succeeded: \(isSuccess)
        status code: \(statusCode)
        decoded value: \(value)
        url response: \(String(describing: urlResponse.debugDescription))
        """
    }
}
