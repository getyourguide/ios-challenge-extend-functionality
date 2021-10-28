//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupViews()
    }

    override func layoutSubviews() {
        layer.cornerRadius = 8
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)

        setupViews()
    }

    func setupViews () {}
}


class StarRatingView: BaseView {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 5

        return stackView
    }()

    override func setupViews() {
        super.setupViews()

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
