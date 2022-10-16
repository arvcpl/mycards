/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class NavigationHeaderView: UIView {
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(ofType: .bold, size: .viewHeader)
        label.textColor = UIColor.appText
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title: String? {
        didSet {
            self.headerLabel.text = title
        }
    }
    
    private func configure() {
        addSubview(headerLabel)
        headerLabel.frame = CGRect(x: 6, y: 4, width: 200, height: 42)
    }
}
