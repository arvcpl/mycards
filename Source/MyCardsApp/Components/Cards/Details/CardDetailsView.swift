/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class CardDetailsView: UIView {
    
    private(set) lazy var cardView: CardView = {
        let view = CardView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    private(set) lazy var infoTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with detailsViewModel: CardDetailsViewModel) {
        let cardViewModel = detailsViewModel.cardViewModel
        let initialFrame = detailsViewModel.initialFrame
        infoTableView.alpha = detailsViewModel.showViewOnInit ? 1.0 : 0.0
        if initialFrame == .zero {
            cardView.isHidden = true
        } else {
            cardView.isHidden = false
            cardView.viewModel = cardViewModel
            cardView.frame = initialFrame
        }
    }
    
    func animateToLargeView() {
        guard !cardView.isHidden else { return }
        let cardWidth = frameWidth - Style.hMargin * 2
        let cardHeight = CardStyle.cardHeight(for: cardWidth)
        cardView.frame = CGRect(x: Style.hMargin, y: Style.vMargin,
                                width: cardWidth, height: cardHeight)
        if let viewModel = cardView.viewModel?.adjust(viewState: .large) {
            cardView.viewModel = viewModel
        }
    }

    private func configure() {
        addSubview(infoTableView)
        NSLayoutConstraint.activate([
            infoTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoTableView.topAnchor.constraint(equalTo: topAnchor),
            infoTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        infoTableView.rowHeight = UITableView.automaticDimension
        infoTableView.register(DividerDataTableViewCell.self)
        infoTableView.register(CardDataTableViewCell.self)
        infoTableView.register(BarcodeDataTableViewCell.self)
        
        addSubview(cardView)
    }
}
