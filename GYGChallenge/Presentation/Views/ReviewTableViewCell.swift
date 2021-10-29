//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import UIKit

final class ReviewTableViewCell: UITableViewCell {
    static let reuseID = "ReviewTableViewCell"

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(all: 20)
        stackView.spacing = 6

        return stackView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 14)

        return label
    }()

    private let starRatingView: StarRatingView = {
        let starRatingView = StarRatingView()
        starRatingView.translatesAutoresizingMaskIntoConstraints = false

        return starRatingView
    }()

    private let authorContentView: AuthorContentView = {
        let authorContentView = AuthorContentView()
        authorContentView.translatesAutoresizingMaskIntoConstraints = false

        return authorContentView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        selectionStyle = .none
        contentView.addSubviews(stackView)

        stackView.addArrangedSubviews(
            dateLabel,
            starRatingView,
            authorContentView
        )

        stackView.pinEdges(to: contentView)
        stackView.setCustomSpacing(10, after: dateLabel)
    }

    func configure(with viewModel: ReviewViewModel) {
        starRatingView.setStarRating(viewModel.rating)
        dateLabel.text = viewModel.dateText
        authorContentView.configure(with : viewModel.authorViewModel)
    }
}
