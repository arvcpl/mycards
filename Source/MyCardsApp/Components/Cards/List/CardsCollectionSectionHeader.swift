/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class CardsCollectionSectionHeader: UICollectionReusableView, IdentifiableView {
    
    static var identifier: String = "CardsCollectionSectionHeader"
    
    var searchWillStart: ((_ textField: UITextField) -> Void)?
    
    private var searchFieldHeightConstraint = NSLayoutConstraint()
    private var titleLabelTopConstraint = NSLayoutConstraint()
    private var titleLabelHeightConstraint = NSLayoutConstraint()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.appText
        label.font = UIFont.appFont(ofType: .bold, size: .regular)
        return label
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.textColor = UIColor.appText
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appSearchPlaceholder]
        searchField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                        attributes: placeholderAttributes)
        searchField.font = UIFont.appFont(ofType: .regular, size: .regular)
        searchField.delegate = self
        return searchField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withViewModel viewModel: CardsViewModel, section: Int) {
        let withSearch = viewModel.shouldDisplayHeaderSearchField(for: section)
        let withTitle = viewModel.shouldDisplayHeaderTitle(for: section)
        let title = viewModel.cardsGrouped[section].title

        titleLabel.text = title
        if withSearch {
            searchFieldHeightConstraint.constant = 30
            titleLabelTopConstraint.constant = 14
            searchTextField.isHidden = false
        } else {
            searchFieldHeightConstraint.constant = 0
            titleLabelTopConstraint.constant = 7
            searchTextField.isHidden = true
        }
        
        if withTitle {
            titleLabelHeightConstraint.constant = 15
            titleLabel.isHidden = false
        } else {
            titleLabelHeightConstraint.constant = 0
            titleLabelTopConstraint.constant = 0
            titleLabel.isHidden = true
        }
    }
    
    private func configure() {
        addSubview(searchTextField)
        searchFieldHeightConstraint = searchTextField.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            searchTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: Style.hMargin),
            searchTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -Style.hMargin),
            searchFieldHeightConstraint
        ])

        addSubview(titleLabel)
        titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 14)
        titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 15)
        NSLayoutConstraint.activate([
            titleLabelTopConstraint,
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Style.hMargin + 2),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Style.hMargin - 2),
            titleLabelHeightConstraint
        ])
    }
}

extension CardsCollectionSectionHeader: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchWillStart?(textField)
        return false
    }
}
