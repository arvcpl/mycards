/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class CardsViewModel: ObservableObject {

    public enum SearchState: Equatable {
        case inactive
        case active
        case searching(_ initialFrame: CGRect? = .none)
    }
    
    @MainActor @Published private(set) var cardsGrouped = [CardsGroupViewModel]()
    @MainActor @Published private(set) var isCardsLoading = false
    @MainActor @Published var searchState = SearchState.inactive {
        didSet {
            if searchState != .searching() && query != nil {
                try? self.load()
            }
        }
    }
    
    private var cellSizesCache = [Bool: CGSize]()
    
    private var query: String?
    
    var isSearching: Bool {
        return query != nil
    }
    
    func load(query: String? = .none) throws {
        self.query = query
        Task.detached(priority: .userInitiated) {
            await MainActor.run {
               self.isCardsLoading = true
            }
            let waitSeconds: UInt64 = 0
            try await Task.sleep(nanoseconds: waitSeconds * 1000000000)
            var cardsGrouped = [CardsGroupViewModel]()
            
            if let query = query {
                let cards = await CardsStore.myCards
                let filteredCards = cards.filter { $0.name.lowercased().contains(query.lowercased())}
                cardsGrouped.append(CardsGroupViewModel(title: "Filtered cards",
                                                        cards: filteredCards,
                                                        recent: false))
            } else {
                let recentCards = await CardsStore.recentCards
                cardsGrouped.append(CardsGroupViewModel(title: "Recently used",
                                                        cards: recentCards,
                                                        recent: true))
                let myCards = await CardsStore.myCards
                cardsGrouped.append(CardsGroupViewModel(title: "My cards",
                                                        cards: myCards,
                                                        recent: false))
            }
            
            await MainActor.run { [cardsGrouped] in
                self.cardsGrouped = cardsGrouped
                self.isCardsLoading = false
            }
        }
    }
}

@MainActor
extension CardsViewModel {
    // MARK: - Cell Render
    func sectionCellSize(for section: Int, width: CGFloat) -> CGSize {
        let cardsGroup = cardsGrouped[section]
        var cellSize = cellSizesCache[cardsGroup.recent]
        if cellSize == nil {
            cellSize = CardsViewModel.cellSize(for: width, recent: cardsGroup.recent)
            cellSizesCache[cardsGroup.recent] = cellSize
        }
        return cellSize ?? .zero
    }
    
    private static func cellSize(for width: CGFloat, recent: Bool) -> CGSize {
        let itemsCountInRow: CGFloat = recent ? 3 : 2
        let margin: CGFloat = 2 * Style.hMargin + (itemsCountInRow - 1) * CardsListStyle.cardsSpacing
        let width: CGFloat = CGFloat((width - margin) / itemsCountInRow)
        let height: CGFloat = CardStyle.cardHeight(for: width)
        return CGSize(width: width, height: height)
    }
}

@MainActor
extension CardsViewModel {
    // MARK: - Section Header Render
    func isLastSection(_ section: Int) -> Bool {
        return section == cardsGrouped.count - 1
    }
    
    func shouldDisplayHeader(for section: Int) -> Bool {
        let shouldDisplaySearchField = shouldDisplayHeaderSearchField(for: section)
        let shouldDisplayTitle = shouldDisplayHeaderTitle(for: section)
        return shouldDisplaySearchField || shouldDisplayTitle
    }
    
    func shouldDisplayHeaderTitle(for section: Int) -> Bool {
        let shouldDisplaySearchField = section == 0
        let shouldDisplayTitle = cardsGrouped.count > 1
        return shouldDisplaySearchField || shouldDisplayTitle
    }
    
    func shouldDisplayHeaderSearchField(for section: Int) -> Bool {
        return section == 0
    }
    
    func sectionHeaderSize(for section: Int) -> CGSize {
        guard !isSearching else { return .zero }
        let shouldDisplaySearchField = shouldDisplayHeaderSearchField(for: section)
        let shouldDisplayTitle = shouldDisplayHeaderTitle(for: section)
        guard shouldDisplaySearchField || shouldDisplayTitle else { return .zero }
        var headerHeight: CGFloat = 0
        if shouldDisplaySearchField {
            headerHeight += 35
        }
        if shouldDisplayTitle {
            headerHeight += 25
        }
        return CGSize(width: .infinity, height: headerHeight)
    }
}
