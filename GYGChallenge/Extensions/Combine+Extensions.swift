//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import Combine

extension Subscribers.Completion {
    var failureError: Failure? {
        guard case let .failure(error) = self else {
            return nil
        }

        return error
    }
}
