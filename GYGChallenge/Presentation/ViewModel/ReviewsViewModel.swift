//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import Combine
import Foundation

enum ReviewsAction: Equatable {
    case viewLoaded
    case willDisplayCell(indexPath: IndexPath)
}

enum ReviewsViewState: Equatable {
    case idle
    case loaded(reviews: [ReviewViewModel])

    var reviewViewModels: [ReviewViewModel] {
        guard case let .loaded(reviews) = self else {
            return []
        }

        return reviews
    }
}

protocol ReviewsViewModelProtocol {
    func send(_ action: ReviewsAction)
    var viewState: AnyPublisher<ReviewsViewState, Never> { get }
}

final class ReviewsViewModel: ReviewsViewModelProtocol {
    private let reviewsRepository: ReviewsRepositoryProtocol
    private let activityID: Int

    let viewState: AnyPublisher<ReviewsViewState, Never>
    private let viewStateSubject = CurrentValueSubject<ReviewsViewState, Never>(.idle)

    private var disposeBag = Set<AnyCancellable>()

    init(
        activityID: Int,
        reviewsRepository: ReviewsRepositoryProtocol
    ) {
        self.activityID = activityID
        self.reviewsRepository = reviewsRepository

        viewState = viewStateSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func send(_ action: ReviewsAction) {
        switch action {
        case .viewLoaded:
            fetchNextPageOfReviews()
        case let .willDisplayCell(indexPath):
            handleWillDisplayItem(at: indexPath)
        }
    }

    private func fetchNextPageOfReviews() {
        reviewsRepository.fetchReviews(
            activityID: activityID,
            offset: viewStateSubject.value.reviewsCount
        )
        .sink(
            receiveCompletion: { completion in
                if let error = completion.failureError {
                    debugPrint(error)
                }
            }, receiveValue: { [viewStateSubject] reviews in
                viewStateSubject.send(
                    viewStateSubject.value.appendingReviews(
                        viewModels: reviews.map(
                            ReviewViewModel.init(from:)
                        )
                    )
                )
            }
        )
        .store(in: &disposeBag)
    }

    private func handleWillDisplayItem(at indexPath: IndexPath) {
        guard indexPath.row == viewStateSubject.value.reviewsCount - 5 else {
            return
        }

        fetchNextPageOfReviews()
    }
}

private extension ReviewViewModel {
    init(from review: Reviews.Review) {
        self.rating = review.rating
        self.dateText = review.created.map(DateFormatter.mediumStyle.string(from:))
        self.title = review.enjoyment
        self.authorViewModel = review.author.map(AuthorViewModel.init(from:))
    }
}

private extension ReviewViewModel.AuthorViewModel {
    init(from author: Reviews.AuthorInfo) {
        var reviewedByContentText = author.fullName
        if let country = author.country {
            reviewedByContentText = "\(reviewedByContentText) - \(country)"
        }

        self.reviewedByText = reviewedByContentText
        self.imageURLString = author.photo
    }
}

private extension ReviewsViewState {
    func appendingReviews(viewModels newViewModels: [ReviewViewModel]) -> Self {
        switch self {
        case .idle:
            return .loaded(reviews: newViewModels)
        case let .loaded(reviews: viewModels):
            return .loaded(
                reviews: viewModels + newViewModels
            )
        }
    }

    var reviewsCount: Int {
        guard case let .loaded(reviews) = self else {
            return 0
        }

        return reviews.count
    }
}

private extension DateFormatter {
    static let mediumStyle: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}
