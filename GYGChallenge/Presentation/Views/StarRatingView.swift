//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import UIKit

final class StarRatingView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 5

        return stackView
    }()

    init() {
        super.init(frame: .zero)

        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        addSubview(stackView)
        stackView.pinEdges(to: self)

        (0 ..< 5).forEach { index in
            let imageView = UIImageView(image: .iconStarGray)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(imageView)
        }
    }

    /// set star rating
    /// - Parameter rating: rating value from api
    func setStarRating(_ rating: Int) {
        guard rating <= 5 else { return }

        for i in 0 ..< rating {
            (stackView.arrangedSubviews[i] as? UIImageView)?.image = .iconStarYellow
        }

        for i in rating ..< 5 {
            (stackView.arrangedSubviews[i] as? UIImageView)?.image = .iconStarGray
        }
    }
}
