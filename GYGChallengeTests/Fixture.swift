//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

@testable import GYGChallenge

enum Fixture {
    static func makeReview(
        enjoyment: String = "super"
    ) -> Reviews.Review {
        .init(
            activityId: 99,
            id: 10,
            author: makeAuthorInfo(),
            created: .distantPast,
            enjoyment: enjoyment,
            rating: 5
        )
    }

    static func makeAuthorInfo() -> Reviews.AuthorInfo {
        .init(
            fullName: "You know who",
            photo: "none",
            country: "London"
        )
    }

    static func makeReviewViewModel(title: String = "super") -> ReviewViewModel {
        .init(
            rating: 5,
            dateText: "Jan 1, 1",
            title: title,
            authorViewModel: makeReviewAuthorViewModel()
        )
    }

    static func makeReviewAuthorViewModel() -> ReviewViewModel.AuthorViewModel {
        .init(
            reviewedByText: "You know who - London",
            imageURLString: "none"
        )
    }
}
