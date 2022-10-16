/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class DividerDataTableViewCell: UITableViewCell, IdentifiableView {
    static var identifier: String = "DividerDataTableViewCell"
    
    var viewModel: DividerViewModel?
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority
                                          horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        guard let viewModel = viewModel else { return .zero }
        return CGSize(width: .infinity, height: viewModel.height)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
