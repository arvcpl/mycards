/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class BarcodeDataTableViewCell: UITableViewCell, IdentifiableView {
    static var identifier: String = "BarcodeDataTableViewCell"
    
    private lazy var barcodeView: BarcodeView = {
        let view = BarcodeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        return view
    }()
    
    private var barcodeHeightConstraint = NSLayoutConstraint()
    
    var viewModel: BarcodeViewModel? {
        didSet {
            barcodeView.viewModel = viewModel
            switch viewModel?.barcodeType {
            case .code128:
                barcodeHeightConstraint.constant = BarcodeStyle.height1D
            case .qr:
                let isQRBig = viewModel?.isQRBig ?? false
                barcodeHeightConstraint.constant = isQRBig ? 10000 : BarcodeStyle.height2D
            case .none:
                barcodeHeightConstraint.constant = BarcodeStyle.height1D
            }
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
        addSubview(barcodeView)
        barcodeHeightConstraint = barcodeView.heightAnchor.constraint(equalToConstant: BarcodeStyle.height1D)
        barcodeHeightConstraint.priority = .defaultHigh
        let barcodeMaxHeightConstraint = barcodeView.heightAnchor.constraint(lessThanOrEqualTo: barcodeView.widthAnchor)
        barcodeMaxHeightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            barcodeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.vMargin),
            barcodeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.vMargin),
            barcodeView.topAnchor.constraint(equalTo: topAnchor),
            barcodeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            barcodeHeightConstraint,
            barcodeMaxHeightConstraint
        ])
    }
}
