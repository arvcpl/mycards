/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

@MainActor
class CardDetailsViewModel: ObservableObject {
    
    static let empty = CardDetailsViewModel(cardViewModel: .empty)
    
    let cardViewModel: CardViewModel
    let initialFrame: CGRect
    let showViewOnInit: Bool
    
    var details = [DataBlockViewModel]()
    
    var name: String {
        return cardViewModel.name
    }
    
    init(cardViewModel: CardViewModel, initialFrame: CGRect = .zero, showViewOnInit: Bool = false) {
        self.cardViewModel = cardViewModel
        self.initialFrame = initialFrame
        self.showViewOnInit = showViewOnInit
        self.details = [
            DividerViewModel(),
            cardViewModel.adjust(viewState: .large),
            DividerViewModel(),
            BarcodeViewModel(barcode: cardViewModel.barcode, type: cardViewModel.barcodeType)
        ]
    }

}
