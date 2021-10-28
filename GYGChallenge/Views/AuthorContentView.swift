//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import UIKit

enum Constants {
    static let imageSize: CGSize = .init(width: 44, height: 44)
}

class AuthorContentView: BaseView {
    let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10

        return stackView
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.constrainSize(to: Constants.imageSize)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.imageSize.height / 2
        imageView.backgroundColor = .lightGray

        return imageView
    }()

    let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2

        return stackView
    }()

    let reviewedByTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "reviewed by"
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 14)

        return label
    }()

    let reviewedByContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16)

        return label
    }()


    override func setupViews() {
        super.setupViews()

        labelsStackView.addArrangedSubviews(reviewedByTitleLabel, reviewedByContentLabel)
        outerStackView.addArrangedSubviews(imageView, labelsStackView)

        addSubview(outerStackView)
        outerStackView.pinEdges(to: self)
    }

    func configure(with authorInfo: AuthorInfo?) {
        guard let authorInfo = authorInfo else { return }

        var reviewedByContentText = authorInfo.fullName
        if let country = authorInfo.country {
            reviewedByContentText = "\(reviewedByContentText) - \(country)"
        }
        reviewedByContentLabel.text = reviewedByContentText

        if
            let photoURL = authorInfo.photo,
            let data = try? Data(contentsOf: URL(string: photoURL)!)
        {
            imageView.image = UIImage(data: data)
        }
    }
}
