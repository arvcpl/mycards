/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class CardView: UIView {
    
    private var varUpdateTasks = [VarUpdateTask]()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appFont(ofType: .bold, size: .regular)
        label.textColor = UIColor.appText
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private var nameCenterX = NSLayoutConstraint()
    private var nameCenterY = NSLayoutConstraint()
    
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
    
    var viewModel: CardViewModel? {
        didSet {
            if viewModel != nil {
                 bind()
            } else {
                unbind()
            }
            nameLabel.isHidden = false
            nameLabel.text = viewModel?.name
            backgroundImageView.image = nil
            if let cardBackgroundColor = viewModel?.color {
                backgroundColor = cardBackgroundColor
                nameLabel.textColor = cardBackgroundColor.textColor
            } else {
                backgroundColor = nil
                nameLabel.textColor = .white.textColor
            }
            
            if viewModel?.backgroundType == .image {
                updateImageUI()
                viewModel?.loadBackgroundImage()
            }
       
            configureViewByState()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViewByState()
    }

    private func bind() {
        unbind()
        guard let viewModel else { return }
        varUpdateTasks.append(Task {
            for await _ in viewModel.$backgroundImage.values {
                guard !Task.isCancelled else { return }
                updateImageUI()
            }
        })
    }
    
    private func updateImageUI() {
        guard let viewModel, let image = viewModel.backgroundImage else { return }
        backgroundImageView.image = image
        nameLabel.isHidden = true
        backgroundColor = nil
    }
    
    private func unbind() {
        varUpdateTasks.unbind()
    }
    
    private func configureViewByState() {
        guard let viewModel = self.viewModel else { return }
        switch viewModel.viewState {
        case .small:
            nameLabel.font = UIFont.appFont(ofType: .bold, size: .small)
            nameLabel.sizeToFit()
            nameCenterX.constant = 0
            nameCenterY.constant = 0
            layoutIfNeeded()
            layer.cornerRadius = CardStyle.cornerRadiusSmall
            backgroundImageView.layer.cornerRadius = CardStyle.cornerRadiusSmall
        case .regular:
            nameLabel.font = UIFont.appFont(ofType: .bold, size: .regular)
            nameLabel.sizeToFit()
            nameCenterX.constant = 0
            nameCenterY.constant = 0
            layoutIfNeeded()
            layer.cornerRadius = CardStyle.cornerRadiusRegular
            backgroundImageView.layer.cornerRadius = CardStyle.cornerRadiusRegular
        case .large:
            nameLabel.font = UIFont.appFont(ofType: .bold, size: .large)
            nameLabel.sizeToFit()
            nameCenterX.constant = -frameWidth / 2  + Style.hMargin + nameLabel.frameWidth / 2
            nameCenterY.constant = -frameHeight / 2  + Style.vMargin + nameLabel.frameHeight / 2
            layoutIfNeeded()
            layer.cornerRadius = CardStyle.cornerRadiusLarge
            backgroundImageView.layer.cornerRadius = CardStyle.cornerRadiusLarge
        }
    }
    
    private func configure() {
        clipsToBounds = true
        
        addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(nameLabel)
        nameCenterX = nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        nameCenterY = nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        let minWidthConstraint = nameLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor,
                                                                  constant: -Style.vMargin * 2)
        minWidthConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            minWidthConstraint,
            nameCenterX,
            nameCenterY])
    }
}
