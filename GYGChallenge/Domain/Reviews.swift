//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import Foundation

struct Reviews: Equatable {
    struct Review: Equatable {
        let activityId: Int
        let id: Int
        let author: AuthorInfo?
        let created: Date?
        let enjoyment: String?
        let rating: Int
    }

    struct AuthorInfo: Equatable {
        let fullName: String
        let photo: String?
        let country: String?
    }

    let averageRating: Float
    let reviews: [Review]
    let totalCount: Int
}

extension Reviews.Review {
    init(from response: ReviewsResponse.Review) {
        self.activityId = response.activityId
        self.id = response.id
        self.author = response.author.map(Reviews.AuthorInfo.init(from:))
        self.created = response.created
        self.enjoyment = response.enjoyment
        self.rating = response.rating
    }
}

extension Reviews.AuthorInfo {
    init(from response: ReviewsResponse.AuthorInfo) {
        self.fullName = response.fullName
        self.photo = response.photo
        self.country = response.country
    }
}
