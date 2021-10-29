//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

public extension JSONDecoder {
    static let iso8601JSONDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
