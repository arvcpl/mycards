/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class CardDetailsViewController: UIViewController {
    private lazy var detailsView: CardDetailsView = {
        let view = CardDetailsView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var navigationHeaderBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appHeader
        view.alpha = 0
        return view
    }()
    
    private lazy var navigationHeaderView: NavigationHeaderView = {
        let view = NavigationHeaderView(frame: CGRect(x: 0, y: 0, width: frameWidth, height: 44))
        view.alpha = 0
        return view
    }()
    
    private lazy var dataSource: DiffableViewDataSource = {
        return DiffableViewDataSource(tableView: detailsView.infoTableView) { tableView, indexPath, controller in
            return controller.cell(for: tableView, indexPath: indexPath)
        }
    }()

    private var viewModel = CardDetailsViewModel.empty
    
    init(viewModel: CardDetailsViewModel) {
        super.init(nibName: .none, bundle: .none)
        self.viewModel = viewModel
        configure()
        self.detailsView.configure(with: viewModel)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTable()
    }
    
    func hideNavigationHeader() {
        navigationHeaderBackgroundView.alpha = 0
        navigationHeaderView.alpha = 0
    }
    
    func animateTransitionsStart() {
        view.isUserInteractionEnabled = false
        detailsView.animateToLargeView()
    }
    
    func animateTransitionsStartEnd() {
        UIView.animate(withDuration: 0.2, animations: {
            self.navigationHeaderView.alpha = 1
            self.detailsView.infoTableView.alpha = 1
        }, completion: { _ in
            self.detailsView.cardView.isHidden = true
            self.view.isUserInteractionEnabled = true
        })
    }
    
    private func updateTable() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        defer {
            dataSource.apply(snapshot, animatingDifferences: false)
        }
        
        let controllers: [CellController] = viewModel.details.map {
            switch $0.type {
            case .divider:
                return DividerDataCellController($0 as! DividerViewModel)
            case .card:
                return CardDataCellController($0 as! CardViewModel)
            case .barcode:
                return BarcodeDataCellController($0 as! BarcodeViewModel)
            }
        }
        
        snapshot.appendSections([0])
        snapshot.appendItems(controllers, toSection: 0)
    }
    
    private func configure() {
        view.addSubview(detailsView)
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        detailsView.infoTableView.delegate = dataSource

        let closeButton = UIBarButtonItem(systemItem: .close, primaryAction: UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))

        navigationItem.rightBarButtonItem = closeButton
        navigationHeaderView.title = viewModel.name
        navigationItem.titleView = navigationHeaderView
        
        view.addSubview(navigationHeaderBackgroundView)
        NSLayoutConstraint.activate([
            navigationHeaderBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationHeaderBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationHeaderBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationHeaderBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

class DiffableViewDataSource: UITableViewDiffableDataSource<Int, CellController>, UITableViewDelegate {

}
