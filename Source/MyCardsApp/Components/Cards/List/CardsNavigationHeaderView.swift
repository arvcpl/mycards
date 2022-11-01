/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class CardsNavigationHeaderView: UIView {

    private var varUpdateTasks = [VarUpdateTask]()

    var addCardHandler: (() -> Void)?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appFont(ofType: .bold, size: .viewHeader)
        label.textColor = UIColor.appText
        label.adjustsFontSizeToFitWidth = false
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.textColor = UIColor.appText
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appSearchPlaceholder]
        searchField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                               attributes: placeholderAttributes)
        searchField.font = UIFont.appFont(ofType: .regular, size: .regular)
        searchField.alpha = 0.0

        let textChangeAction = UIAction() { _ in
            try? self.viewModel?.load(query: searchField.text)
        }
        let editingDidBeginAction = UIAction() { _ in
            self.viewModel?.searchState = .searching()
        }
        let editingDidEndAction = UIAction() { _ in
            self.viewModel?.searchState = .active
        }
        searchField.addAction(textChangeAction, for: .editingChanged)
        searchField.addAction(editingDidEndAction, for: .editingDidEndOnExit)
        searchField.addAction(editingDidBeginAction, for: .editingDidBegin)
        return searchField
    }()

    private lazy var cancelButton: UIButton = {
        let action = UIAction(title: "Cancel", handler: { [weak self] _ in
            self?.viewModel?.searchState = .active
        })
        let button = UIButton(primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0.0
        button.tintColor = .appAccent
        return button
    }()

    private lazy var addButton: UIButton = {
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let action = UIAction(image: UIImage(systemName: "plus.app", withConfiguration: config), handler: { [weak self] _ in
            self?.addCardHandler?()
        })
        let button = UIButton(primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .appAccent
        return button
    }()

    var viewModel: CardsViewModel?

    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    func bind() {
        unbind()
        guard let viewModel = viewModel else { return }

        func handleSearchStateChange(animate: Bool = true) {
            switch viewModel.searchState {
            case .inactive:
                hideSearch(animate: animate)
                endSearch(animate: animate)
            case .active:
                showSearch(animate: animate)
                endSearch(animate: animate)
            case .searching(let initialFrame):
                showSearch(initialFrame, animate: animate)
                startSearch(animate: animate)
            }
        }

        varUpdateTasks.append(Task {
            for await _ in viewModel.$searchState.values {
                handleSearchStateChange()
            }
        })

        handleSearchStateChange(animate: false)
    }

    func unbind() {
        varUpdateTasks.unbind()
    }

    private var cancelButtonWidthConstraint = NSLayoutConstraint()
    private var searchFieldTrailingConstraint = NSLayoutConstraint()

    private func configure() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 220),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.heightAnchor.constraint(equalToConstant: elementHeight)
        ])

        addSubview(cancelButton)
        cancelButtonWidthConstraint = cancelButton.widthAnchor.constraint(equalToConstant: cancelButtonWidthInactive)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cancelButtonWidthConstraint,
            cancelButton.heightAnchor.constraint(equalToConstant: elementHeight)
        ])

        addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -10),
            searchField.heightAnchor.constraint(equalToConstant: elementHeight)
        ])

    }
}

extension CardsNavigationHeaderView {
    // MARK: - State Transitions
    private func startSearch(animate: Bool = true) {
        guard addButton.alpha == 1.0 else { return }
        cancelButtonWidthConstraint.constant = cancelButtonWidthActive
        UIView.animate(withDuration: animate ? 0.2 : 0.0, animations: {
            self.addButton.alpha = 0.0
            self.cancelButton.alpha = 1.0
            self.layoutIfNeeded()
        })
    }

    private func endSearch(animate: Bool = true) {
        guard addButton.alpha == 0.0 else { return }
        searchField.text = nil
        searchField.resignFirstResponder()
        cancelButtonWidthConstraint.constant = cancelButtonWidthInactive
        UIView.animate(withDuration: animate ? 0.2 : 0.0, animations: {
            self.addButton.alpha = 1.0
            self.cancelButton.alpha = 0.0
            self.layoutIfNeeded()
        })
    }

    private func showSearch(_ initialFrame: CGRect? = .none, animate: Bool = true) {
        guard searchField.alpha == 0 else { return }
        if let initialFrame = initialFrame {
            searchField.frame = initialFrame
            searchField.alpha = 1.0
            searchField.becomeFirstResponder()
            UIView.animate(withDuration: animate ? 0.2 : 0.0, animations: {
                self.titleLabel.alpha = 0.0
            })
        } else {
            UIView.animate(withDuration: animate ? 0.2 : 0.0, animations: {
                self.searchField.alpha = 1.0
                self.titleLabel.alpha = 0.0
            })
        }
    }

    private func hideSearch(animate: Bool = true) {
        guard searchField.alpha == 1.0 else { return }
        UIView.animate(withDuration: animate ? 0.2 : 0.0, animations: {
            self.searchField.alpha = 0.0
            self.titleLabel.alpha = 1.0
        })
    }
}

extension CardsNavigationHeaderView {
    // MARK: - State Rects
    private var elementHeight: CGFloat {
        return 30
    }

    private var cancelButtonWidthInactive: CGFloat {
        return 20
    }

    private var cancelButtonWidthActive: CGFloat {
        let textSize = cancelButton.sizeThatFits(CGSize(width: .infinity, height: elementHeight))
        let buttonWidth = textSize.width + 20
        return buttonWidth
    }
}
