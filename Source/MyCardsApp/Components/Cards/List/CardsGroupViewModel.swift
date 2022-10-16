/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class CardsGroupViewModel {
    let title: String
    let cards: [CardViewModel]
    let recent: Bool
    
    init(title: String, cards: [CardViewModel], recent: Bool) {
        self.title = title
        self.cards = cards
        self.recent = recent
    }
}
