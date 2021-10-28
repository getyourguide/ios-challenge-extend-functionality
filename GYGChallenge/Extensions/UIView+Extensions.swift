//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import UIKit

extension UIView {
    func pinEdges(to view: UIView, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])
    }

    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }

    func constrainSize(to size: CGSize) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size.height),
            widthAnchor.constraint(equalToConstant: size.width)
        ])
    }

    func constrainHeight(to height: CGFloat) {
        heightAnchor
            .constraint(equalToConstant: height)
            .isActive = true
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(addArrangedSubview)
    }
}

extension UIEdgeInsets {
    init(all: CGFloat) {
        self.init(
            top: all,
            left: all,
            bottom: all,
            right: all
        )
    }
}
