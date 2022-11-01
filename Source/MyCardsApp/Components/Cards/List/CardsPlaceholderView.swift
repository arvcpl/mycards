/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class CardsPlaceholderView: UIView {

    var addCardHandler: (() -> Void)?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular, scale: .large)
        let cardImage = UIImage(systemName: "creditcard", withConfiguration: imageConfig)
        imageView.image = cardImage
        imageView.tintColor = .appText
        imageView.alpha = 0.2
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appFont(ofType: .bold, size: .viewHeader)
        label.textColor = UIColor.appText
        label.textAlignment = .center
        label.text = "Add your Cards"
        return label
    }()

    private lazy var addButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .large)
        let action = UIAction(image: UIImage(systemName: "plus.app", withConfiguration: config), handler: { [weak self] _ in
            self?.addCardHandler?()
        })
        let button = UIButton(primaryAction: action)
        button.tintColor = .appAccent
        return button
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Style.hMargin),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -Style.hMargin),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(addButton)
    }
}
