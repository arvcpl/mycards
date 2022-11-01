/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class CardsViewController: UIViewController {
    
    private let viewModel: CardsViewModel
    private var varUpdateTasks = [VarUpdateTask]()
    private let searchingContentOffset = CGPoint(x: 0, y: 45)

    private lazy var cardsCollectionLayout: MinHeightCollectionViewFlowLayout = {
        return MinHeightCollectionViewFlowLayout()
    }()

    private lazy var cardsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: cardsCollectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var placeholderView: CardsPlaceholderView = {
        let view = CardsPlaceholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let action = UIAction(handler: { [viewModel] _ in
            try? viewModel.load()
        })
        let refreshControl = UIRefreshControl(frame: .zero, primaryAction: action)
        return refreshControl
    }()
    
    private lazy var navigationHeaderView: CardsNavigationHeaderView = {
        let view = CardsNavigationHeaderView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title = "My Cards"
        return view
    }()

    init(viewModel: CardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .none)
        cardsCollectionLayout.viewModel = viewModel
        navigationHeaderView.viewModel = viewModel
        configure()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        cardsCollectionView.register(CardCollectionCell.self)
        cardsCollectionView.registerHeader(CardsCollectionSectionHeader.self)
        cardsCollectionView.addSubview(refreshControl)
        try? viewModel.load()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardsCollectionLayout.minHeight = frameHeight
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        navigationHeaderView.bind()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unbind()
        navigationHeaderView.unbind()
    }
    
    private func bind() {
        unbind()

        func handleCardsLoadingStateChange() {
            if viewModel.cardsLoadState == .loading {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }

        func handleCardsListChange() {
            cardsCollectionView.reloadData()
            if viewModel.searchState == .active || viewModel.searchState == .searching() {
                // set content offset while switching from searching -> active
                cardsCollectionView.setContentOffset(searchingContentOffset, animated: false)
            }
            if viewModel.cardsLoadState == .loaded
                && !viewModel.isSearching
                && viewModel.cardsGrouped.isEmpty {
                placeholderView.isHidden = false
                cardsCollectionView.isHidden = true
            } else {
                placeholderView.isHidden = true
                cardsCollectionView.isHidden = false
            }
        }

        varUpdateTasks.append(Task {
            for await _ in viewModel.$cardsGrouped.values {
                handleCardsListChange()
            }
        })
        varUpdateTasks.append(Task {
            for await _ in viewModel.$cardsLoadState.values {
                handleCardsLoadingStateChange()
            }
        })

        handleCardsLoadingStateChange()
        handleCardsListChange()
    }
    
    private func unbind() {
        varUpdateTasks.unbind()
    }
    
    private func configure() {
        setTitleView(navigationHeaderView)
        view.backgroundColor = .systemBackground

        view.addSubview(cardsCollectionView)
        NSLayoutConstraint.activate([
            cardsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cardsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cardsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cardsCollectionView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])

        view.addSubview(placeholderView)
        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private class MinHeightCollectionViewFlowLayout: UICollectionViewFlowLayout {
        var minHeight: CGFloat = 0
        var viewModel: CardsViewModel?
        override var collectionViewContentSize: CGSize {
            let originalSize = super.collectionViewContentSize
            let minHeight = viewModel?.cardsLoadState == .loaded ? self.minHeight : 0
            return CGSize(width: originalSize.width, height: max(originalSize.height, minHeight))
        }
    }
}

extension CardsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !viewModel.isSearching && (scrollView.isTracking || scrollView.isDecelerating) else { return }
        let offsetWhenSearchIsVisible = 37.0
        if scrollView.contentOffset.y > offsetWhenSearchIsVisible && viewModel.searchState == .inactive {
            viewModel.searchState = .active 
        } else if scrollView.contentOffset.y <= offsetWhenSearchIsVisible && viewModel.searchState != .inactive {
            viewModel.searchState = .inactive
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cardViewModel = viewModel.cardsGrouped[indexPath.section].cards[indexPath.row]
        guard let cellLayoutAttributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let cellFrameInWindow = collectionView.convert(cellLayoutAttributes.frame, to: nil)
        let adjustedFrame = cellFrameInWindow.offsetBy(dx: 0, dy: -self.cardsCollectionView.frame.origin.y)
        showCard(for: cardViewModel, initialFrame: adjustedFrame)
    }
    
    private func showCard(for cardViewModel: CardViewModel, initialFrame: CGRect) {
        let cardDetailsViewModel = CardDetailsViewModel(cardViewModel: cardViewModel,
                                                        initialFrame: initialFrame)
        let cardViewController = CardDetailsViewController(viewModel: cardDetailsViewModel)
        let cardNavigationController = CardNavigationController(rootViewController: cardViewController)
        present(cardNavigationController, animated: true)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.cardsGrouped.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
        if viewModel.shouldDisplayHeader(for: indexPath.section) && kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader: CardsCollectionSectionHeader = collectionView.dequeueReusableSupplementaryView(for: indexPath)
            sectionHeader.configure(withViewModel: viewModel, section: indexPath.section)
            sectionHeader.searchWillStart = {[weak self] searchTextField in
                if let self = self {
                    let textFieldAdjustedFrame = collectionView.convert(searchTextField.frame, to: self.navigationHeaderView)
                    self.viewModel.searchState = .searching(textFieldAdjustedFrame)
                    searchTextField.isHidden = true
                    Task { @MainActor in
                        UIView.animate(withDuration: 0.2) {
                            collectionView.setContentOffset(self.searchingContentOffset,
                                                             animated: false)
                         } completion: { _ in
                             searchTextField.isHidden = false
                         }
                    }
                }
                
            }
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.sectionHeaderSize(for: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cardsGrouped[section].cards.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CardCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        let cardsGroup = viewModel.cardsGrouped[indexPath.section]
        cell.viewModel = cardsGroup.cards[indexPath.row]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sectionCellSize(for: indexPath.section, width: frameWidth)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CardsListStyle.cardsSpacing,
                            left: Style.hMargin,
                            bottom: viewModel.isLastSection(section) ? CardsListStyle.cardsSpacing : 0.0,
                            right: Style.hMargin)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CardsListStyle.cardsSpacing
    }
}
