//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import Foundation

struct ReviewsResponse: Decodable, Equatable {
    struct Review: Decodable, Equatable {
        let activityId: Int
        let id: Int
        let author: AuthorInfo?
        let created: Date?
        let enjoyment: String?
        let rating: Int
    }

    struct AuthorInfo: Decodable, Equatable {
        let fullName: String
        let photo: String?
        let country: String?
    }

    let averageRating: Float
    let pagination: Pagination?
    let reviews: [Review]
    let totalCount: Int

    struct Pagination: Decodable, Equatable {
        let limit: Int?
        let offset: Int?
    }
}
