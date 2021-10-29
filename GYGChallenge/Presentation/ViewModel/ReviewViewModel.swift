//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

struct ReviewViewModel: Hashable {
    struct AuthorViewModel: Hashable {
        let reviewedByText: String?
        let imageURLString: String?
    }

    let rating: Int
    let dateText: String?
    let title: String?
    let authorViewModel: AuthorViewModel?
}
