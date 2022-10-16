/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class BarcodeView: UIView {
    
    private let barcodeMargin = 10.0
    
    private var bottomConstraint = NSLayoutConstraint()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var barcodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var barcodeNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appFont(ofType: .regular, size: .regular)
        label.textColor = .black
        label.textAlignment = .center
        return label
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
    
    var viewModel: BarcodeViewModel? {
        didSet {
            if let viewModel = viewModel {
                barcodeImageView.image = viewModel.barcodeImage
                barcodeNumberLabel.attributedText = viewModel.barcodeText
                switch viewModel.barcodeType {
                case .code128:
                    barcodeImageView.contentMode = .scaleAspectFill
                    barcodeNumberLabel.isHidden = false
                    bottomConstraint.constant = -3
                case .qr:
                    barcodeImageView.contentMode = .scaleAspectFit
                    if viewModel.isQRBig {
                        barcodeNumberLabel.isHidden = true
                        bottomConstraint.constant = -barcodeMargin
                    } else {
                        barcodeNumberLabel.isHidden = false
                        bottomConstraint.constant = -5
                    }
                }
            } else {
                barcodeImageView.image = nil
            }
        }
    }
    
    private func configure() {
        addSubview(contentStackView)
        bottomConstraint = contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: barcodeMargin),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -barcodeMargin),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: barcodeMargin),
            bottomConstraint
        ])
        
        contentStackView.addArrangedSubview(barcodeImageView)
        NSLayoutConstraint.activate([
            barcodeImageView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            barcodeImageView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor)
        ])
        
        contentStackView.addArrangedSubview(barcodeNumberLabel)
        NSLayoutConstraint.activate([
            barcodeNumberLabel.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            barcodeNumberLabel.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            barcodeNumberLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
}
