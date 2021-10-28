//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    func setupViews() {}
}


class ReviewTableViewCell: BaseTableViewCell {
    static let reuseID = "ReviewTableViewCell"

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(all: 20)
        stackView.spacing = 6

        return stackView
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 14)

        return label
    }()

    let starRatingView: StarRatingView = {
        let starRatingView = StarRatingView()
        starRatingView.translatesAutoresizingMaskIntoConstraints = false

        return starRatingView
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0

        return label
    }()

    let authorContentView: AuthorContentView = {
        let authorContentView = AuthorContentView()
        authorContentView.translatesAutoresizingMaskIntoConstraints = false

        return authorContentView
    }()

    override func setupViews() {
        super.setupViews()

        selectionStyle = .none
        contentView.addSubviews(stackView)

        stackView.addArrangedSubviews(
            dateLabel,
            starRatingView,
            messageLabel,
            authorContentView
        )

        stackView.pinEdges(to: contentView)
        stackView.setCustomSpacing(10, after: dateLabel)
    }

    func configure(with review: Review) {
        starRatingView.setStarRating(review.rating)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = review.created.map(dateFormatter.string(from:))
        messageLabel.text = review.message
        authorContentView.configure(with : review.author)
    }
}
