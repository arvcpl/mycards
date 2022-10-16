/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class CardDataTableViewCell: UITableViewCell, IdentifiableView {
    static var identifier: String = "CardDataTableViewCell"
    
    private lazy var cardView: CardView = {
        let view = CardView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewModel: CardViewModel? {
        didSet {
            cardView.viewModel = viewModel
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.viewModel = nil
    }

    private func configure() {
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(cardView)
        let heightConstraint = cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: CardStyle.cardHeight(for: 1))
        heightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.hMargin),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.hMargin),
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightConstraint
        ])
    }
}
