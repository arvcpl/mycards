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
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = true
        label.font = UIFont.appFont(ofType: .bold, size: .viewHeader)
        label.textColor = UIColor.appText
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.translatesAutoresizingMaskIntoConstraints = true
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
        button.tintColor = .appAccent
        return button
    }()
    
    var viewModel: CardsViewModel?
    
    var title: String? {
        didSet {
            self.headerLabel.text = title
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addButton.frame = addButtonFrame()
    }

    func bind() {
        unbind()
        guard let viewModel = viewModel else { return }
        varUpdateTasks.append(Task {
            for await searchState in viewModel.$searchState.values {
                switch searchState {
                case .inactive:
                    self.hideSearch()
                    self.endSearch()
                case .active:
                    self.showSearch()
                    self.endSearch()
                case .searching(let initialFrame):
                    self.showSearch(initialFrame)
                    self.startSearch()
                }
            }
        })
    }
    
    func unbind() {
        varUpdateTasks.unbind()
    }
    
    private func configure() {
        addSubview(headerLabel)
        headerLabel.frame = CGRect(x: 6, y: 4, width: 200, height: 42)
        
        addSubview(searchField)
       
        addSubview(addButton)
        
        addSubview(cancelButton)
        cancelButton.frame = cancelButtonFrameInactive()
    }
}

extension CardsNavigationHeaderView {
    // MARK: - State Transitions
    private func startSearch() {
        guard addButton.alpha == 1.0 else { return }
        UIView.animate(withDuration: 0.2, animations: {
            self.addButton.alpha = 0.0
            self.cancelButton.alpha = 1.0
            self.searchField.frame = self.searchFieldFrameActive()
            self.cancelButton.frame = self.cancelButtonFrameActive()
        })
    }
    
    private func endSearch() {
        guard addButton.alpha == 0.0 else { return }
        searchField.text = nil
        searchField.resignFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.addButton.alpha = 1.0
            self.cancelButton.alpha = 0.0
            self.searchField.frame = self.searchFieldFrameInactive()
            self.cancelButton.frame = self.cancelButtonFrameInactive()
        })
    }
    
    private func showSearch(_ initialFrame: CGRect? = .none) {
        guard searchField.alpha == 0 else { return }
        if let initialFrame = initialFrame {
            searchField.frame = initialFrame
            searchField.alpha = 1.0
            searchField.becomeFirstResponder()
            UIView.animate(withDuration: 0.2, animations: {
                self.headerLabel.alpha = 0.0
            })
        } else {
            searchField.frame = searchFieldFrameInactive()
            UIView.animate(withDuration: 0.2, animations: {
                self.searchField.alpha = 1.0
                self.headerLabel.alpha = 0.0
            })
        }
    }
    
    private func hideSearch() {
        guard searchField.alpha == 1.0 else { return }
        UIView.animate(withDuration: 0.2, animations: {
            self.searchField.alpha = 0.0
            self.headerLabel.alpha = 1.0
        })
    }
}

extension CardsNavigationHeaderView {
    // MARK: - State Rects
    private var elementHeight: CGFloat {
        return 30
    }
    
    private func searchFieldFrameInactive() -> CGRect {
        let rect = CGRect(x: 7, y: 7, width: frameWidth - 43, height: elementHeight)
        return rect
    }
    
    private func searchFieldFrameActive() -> CGRect {
        let cancelButtonFrame = cancelButtonFrameActive()
        let width = frameWidth - cancelButtonFrame.size.width - 20
        return CGRect(x: 7, y: 7, width: width, height: elementHeight)
    }
    
    private func addButtonFrame() -> CGRect {
        return CGRect(x: frameWidth - 40 + 10, y: 7, width: 40, height: elementHeight)
    }
        
    private func cancelButtonFrameInactive() -> CGRect {
        var originX: CGFloat {
            return frameWidth - buttonWidth
        }
        
        let buttonWidth = 40.0
        
        return CGRect(x: originX, y: 7, width: buttonWidth, height: elementHeight)
    }
    
    private func cancelButtonFrameActive() -> CGRect {
        var buttonWidth: CGFloat {
            let textSize = cancelButton.sizeThatFits(CGSize(width: .infinity, height: elementHeight))
            let buttonWidth = textSize.width + 20
            return buttonWidth
        }
        
        let originX = frameWidth - buttonWidth
        
        return CGRect(x: originX, y: 7, width: buttonWidth, height: elementHeight)
    }
}
