//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import Foundation

struct ReviewsResponse: Codable {
    var averageRating: Float
    var pagination: Pagination?
    var reviews: [Review]
    var totalCount: Int
}

struct Review: Codable, Equatable {
    var activityId: Int
    var id: Int
    var author: AuthorInfo?
    var created: Date?
    var enjoyment: String?
    var message: String?
    var rating: Int
}

struct AuthorInfo: Codable, Equatable {
    var fullName: String
    var photo: String?
    var country: String?
}

struct Pagination: Codable, Equatable {
    var limit: Int?
    var offset: Int?
}
