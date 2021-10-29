//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import Combine
import UIKit

private enum Constants {
    static let imageSize: CGSize = .init(width: 44, height: 44)
}

final class AuthorContentView: UIView {
    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10

        return stackView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.constrainSize(to: Constants.imageSize)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.imageSize.height / 2
        imageView.backgroundColor = .lightGray

        return imageView
    }()

    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2

        return stackView
    }()

    private let reviewedByTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "reviewed by"
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 14)

        return label
    }()

    private let reviewedByContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16)

        return label
    }()

    private var cancellable: AnyCancellable?
    private let urlSession: URLSession
    private let mainQueue: DispatchQueue

    init(
        urlSession: URLSession = .shared,
        mainQueue: DispatchQueue = .main
    ) {
        self.urlSession = urlSession
        self.mainQueue = mainQueue

        super.init(frame: .zero)

        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        labelsStackView.addArrangedSubviews(reviewedByTitleLabel, reviewedByContentLabel)
        outerStackView.addArrangedSubviews(imageView, labelsStackView)

        addSubview(outerStackView)
        outerStackView.pinEdges(to: self)
    }

    func configure(with viewModel: ReviewViewModel.AuthorViewModel?) {
        guard let viewModel = viewModel else {
            reviewedByContentLabel.text = nil
            imageView.image = nil
            
            return
        }

        reviewedByContentLabel.text = viewModel.reviewedByText

        cancellable?.cancel()
        if
            let imageURLString = viewModel.imageURLString,
            let imageURL = URL(string: imageURLString)
        {
            cancellable = urlSession.dataTaskPublisher(for: imageURL)
                .receive(on: mainQueue)
                .sink(
                    receiveCompletion: { completion in
                        if let error = completion.failureError {
                            debugPrint(error)
                        }
                    },
                    receiveValue: { [weak self] data, _ in
                        self?.imageView.image = UIImage(data: data)
                    }
                )
        } else {
            imageView.image = nil
        }
    }
}
