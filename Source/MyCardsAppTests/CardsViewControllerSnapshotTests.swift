/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */
import XCTest
@testable import MyCardsApp
import SnapshotTesting

@MainActor
final class CardsViewControllerSnapshotTests: XCTestCase, SnapshotTesting {

    func testDisplayEmptyWhenNotLoaded() throws {
        let sut = createSUT(cardsGrouped: [], cardsLoadState: .initial, searchState: .inactive)
        assertSnapshot(for: sut)
    }

    func testDisplaySpinnerWhenLoading() throws {
        let sut = createSUT(cardsGrouped: [], cardsLoadState: .loading, searchState: .inactive)
        assertSnapshot(for: sut)
    }

    func testDisplayPlaceholderWhenEmptyAndLoaded() throws {
        let sut = createSUT(cardsGrouped: [], cardsLoadState: .loaded, searchState: .inactive)
        assertSnapshot(for: sut)
    }

    func testDisplayListWhenLoadedOneSection() throws {
        var cardsGrouped = [CardsGroupViewModel]()
        cardsGrouped.append(createCardsGroupViewModel(title: "My Cards"))
        let sut = createSUT(cardsGrouped: cardsGrouped, cardsLoadState: .loaded, searchState: .inactive)
        assertSnapshot(for: sut)
    }

    func testDisplayListWhenLoadedTwoSections() throws {
        var cardsGrouped = [CardsGroupViewModel]()
        cardsGrouped.append(createRecentCardsGroupViewModel(title: "Recently used"))
        cardsGrouped.append(createCardsGroupViewModel(title: "My Cards"))
        let sut = createSUT(cardsGrouped: cardsGrouped, cardsLoadState: .loaded, searchState: .inactive)
        assertSnapshot(for: sut)
    }

    func testDisplayShortListWhenSearchInHeader() throws {
        var cardsGrouped = [CardsGroupViewModel]()
        cardsGrouped.append(createCardsGroupViewModel(title: "My Cards"))
        let sut = createSUT(cardsGrouped: cardsGrouped, cardsLoadState: .loaded, searchState: .active)
        assertSnapshot(for: sut)
    }

    func testDisplayLongListWhenSearchInHeader() throws {
        var cardsGrouped = [CardsGroupViewModel]()
        cardsGrouped.append(createCardsGroupViewModel(title: "My Cards", short: false))
        let sut = createSUT(cardsGrouped: cardsGrouped, cardsLoadState: .loaded, searchState: .active)
        assertSnapshot(for: sut)
    }

    func testDisplayShortListWhenSearching() throws {
        var cardsGrouped = [CardsGroupViewModel]()
        cardsGrouped.append(createCardsGroupViewModel(title: "My Cards"))
        let sut = createSUT(cardsGrouped: cardsGrouped, cardsLoadState: .loaded, searchState: .searching())
        assertSnapshot(for: sut)
    }

    func testDisplayLongListWhenSearching() throws {
        var cardsGrouped = [CardsGroupViewModel]()
        cardsGrouped.append(createCardsGroupViewModel(title: "My Cards", short: false))
        let sut = createSUT(cardsGrouped: cardsGrouped, cardsLoadState: .loaded, searchState: .searching())
        assertSnapshot(for: sut)
    }

    // MARK: - Helpers

    private func createSUT(cardsGrouped: [CardsGroupViewModel],
                           cardsLoadState: CardsViewModel.LoadState,
                           searchState: CardsViewModel.SearchState) -> UINavigationController {
        let viewModel = CardsViewModelMock(cardsGrouped: cardsGrouped,
                                           cardsLoadState: cardsLoadState,
                                           searchState: searchState)
        let cardsViewController = CardsViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: cardsViewController)
        navigationController.loadViewIfNeeded()
        return navigationController
    }

    private class CardsViewModelMock: CardsViewModel {
        override func load(query: String? = .none) throws {}
    }

    private func createRecentCardsGroupViewModel(title: String) -> CardsGroupViewModel {
        let recentCards = [
            CardViewModel(id: UUID(), name: "SAFEWAY",
                          barcode: "D66447954123028", barcodeType: .code128, color: .orange, backgroundType: .image,
                          backgroundImage: UIImage(named: "card_safeway"), recent: true, viewState: .small),
            CardViewModel(id: UUID(), name: "IKI",
                          barcode: "9989069187925", barcodeType: .code128, color: .green, backgroundType: .color,
                          recent: true, viewState: .small),
            CardViewModel(id: UUID(), name: "BENU",
                          barcode: "BENU010635323", barcodeType: .code128, color: .darkGray, backgroundType: .color,
                          recent: true, viewState: .small),
            CardViewModel(id: UUID(), name: "VERO",
                          barcode: "682665648", barcodeType: .code128, color: .brown, backgroundType: .image,
                          backgroundImage: UIImage(named: "card_vero"), recent: true, viewState: .small),
            CardViewModel(id: UUID(), name: "LIDL",
                          barcode: "77700005493524623", barcodeType: .qr, color: .blue, backgroundType: .color,
                          recent: true, viewState: .small),
            CardViewModel(id: UUID(), name: "ERMITAZAS",
                          barcode: "L0040618542", barcodeType: .code128, color: .orange, backgroundType: .image,
                          backgroundImage: UIImage(named: "card_ermitazas"), recent: true, viewState: .small)
        ]

        let group = CardsGroupViewModel(title: title,
                                        cards: recentCards,
                                        recent: true)
        return group
    }

    private func createCardsGroupViewModel(title: String, short: Bool = true) -> CardsGroupViewModel {
        let cards = [
            CardViewModel(id: UUID(), name: "IKI",
                          barcode: "9989069187925", barcodeType: .code128, color: .green, backgroundType: .color,
                          recent: false, viewState: .regular),
            CardViewModel(id: UUID(), name: "BENU",
                          barcode: "BENU010635323", barcodeType: .code128, color: .darkGray, backgroundType: .color,
                          recent: false, viewState: .regular),
            CardViewModel(id: UUID(), name: "VERO",
                          barcode: "682665648", barcodeType: .code128, color: .brown, backgroundType: .image,
                          backgroundImage: UIImage(named: "card_vero"), recent: false, viewState: .regular),
            CardViewModel(id: UUID(), name: "LIDL",
                          barcode: "77700005493524623", barcodeType: .qr, color: .blue, backgroundType: .color,
                          recent: false, viewState: .regular),
            CardViewModel(id: UUID(), name: "ERMITAZAS",
                          barcode: "L0040618542", barcodeType: .code128, color: .orange,
                          backgroundType: .image, backgroundImage: UIImage(named: "card_ermitazas"),
                          recent: false, viewState: .regular),
            CardViewModel(id: UUID(), name: "SAFEWAY",
                          barcode: "D66447954123028", barcodeType: .code128, color: .orange, backgroundType: .image,
                          backgroundImage: UIImage(named: "card_safeway"),
                          recent: false, viewState: .regular),
            CardViewModel(id: UUID(), name: "IKI",
                          barcode: "9989069187925", barcodeType: .code128, color: .green, backgroundType: .color,
                          recent: false, viewState: .regular),
            CardViewModel(id: UUID(), name: "BENU",
                          barcode: "BENU010635323", barcodeType: .code128, color: .darkGray, backgroundType: .color,
                          recent: false, viewState: .regular)
        ]

        let allCards = short ? cards : cards + cards + cards

        let group = CardsGroupViewModel(title: title,
                                        cards: allCards,
                                        recent: false)
        return group
    }

}
