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
final class CardDetailsViewControllerSnapshotTests: XCTestCase, SnapshotTesting {

    func testDisplayShortTitleBarcodeImage() throws {
        let cardViewModel = CardViewModel(id: UUID(), name: "SHORT TITLE",
                                          barcode: "BARCODE", barcodeType: .code128, color: .orange,
                                          backgroundType: .image,
                                          backgroundImage: UIImage(named: "card_safeway"),
                                          recent: true, viewState: .large)
        let sut = createSUT(viewModel: cardViewModel)
        assertSnapshot(for: sut)
    }

    func testDisplayLongTitleBarcodeImage() throws {
        let cardViewModel = CardViewModel(id: UUID(), name: "SOME CRAZY LONG CARD TITLE WHICH DOES NOT FIT",
                                          barcode: "BARCODE", barcodeType: .code128, color: .orange,
                                          backgroundType: .image,
                                          backgroundImage: UIImage(named: "card_safeway"),
                                          recent: true, viewState: .large)
        let sut = createSUT(viewModel: cardViewModel)
        assertSnapshot(for: sut)
    }

    func testDisplayShortTitleBarcodeNoImage() throws {
        let cardViewModel = CardViewModel(id: UUID(), name: "SHORT TITLE",
                                          barcode: "BARCODE", barcodeType: .code128, color: .orange,
                                          backgroundType: .color,
                                          recent: true, viewState: .large)
        let sut = createSUT(viewModel: cardViewModel)
        assertSnapshot(for: sut)
    }

    func testDisplayLongTitleBarcodeNoImage() throws {
        let cardViewModel = CardViewModel(id: UUID(), name: "SOME CRAZY LONG CARD TITLE WHICH DOES NOT FIT",
                                          barcode: "BARCODE", barcodeType: .code128, color: .orange,
                                          backgroundType: .color,
                                          recent: true, viewState: .large)
        let sut = createSUT(viewModel: cardViewModel)
        assertSnapshot(for: sut)
    }

    func testDisplayShortTitleShortQRNoImage() throws {
        let cardViewModel = CardViewModel(id: UUID(), name: "SHORT QR",
                                          barcode: "QR CODE", barcodeType: .qr, color: .orange,
                                          backgroundType: .color,
                                          recent: true, viewState: .large)
        let sut = createSUT(viewModel: cardViewModel)
        assertSnapshot(for: sut)
    }

    func testDisplayShortTitleLongQRNoImage() throws {
        let cardViewModel = CardViewModel(id: UUID(), name: "LONG QR",
                                          barcode: "QR CODE WHICH IS LONGER THAN READABLE AND SHOULD NOT BE DISPLAYED",
                                          barcodeType: .qr, color: .orange,
                                          backgroundType: .color,
                                          recent: true, viewState: .large)
        let sut = createSUT(viewModel: cardViewModel)
        assertSnapshot(for: sut)
    }

    // MARK: - Helpers

    private func createSUT(viewModel: CardViewModel, initialFrame: CGRect = .zero) -> UINavigationController {
        let cardDetailsViewModel = CardDetailsViewModel(cardViewModel: viewModel,
                                                        initialFrame: .zero, showViewOnInit: true)
        let cardViewController = CardDetailsViewController(viewModel: cardDetailsViewModel)
        let navigationController = CardNavigationController(rootViewController: cardViewController)
        navigationController.loadViewIfNeeded()
        return navigationController
    }

    private var testDevices: [Snapshotting<UIViewController, UIImage>] {
        return [
            .image(on: .iPhone13, precision: 0.99, traits: .init(userInterfaceStyle: .dark)),
            .image(on: .iPhone13, precision: 0.99, traits: .init(userInterfaceStyle: .light)),
            .image(on: .iPhoneSe, precision: 0.99, traits: .init(userInterfaceStyle: .dark)),
            .image(on: .iPhoneSe, precision: 0.99, traits: .init(userInterfaceStyle: .light))
        ]
    }

    private func assertSnapshot(
        for viewController: UIViewController,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        testDevices.forEach { device in
            assertSnapshot(matching: viewController, as: device, file: file, testName: testName, line: line)
        }
    }
}
