/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import Foundation

enum DataBlockType {
    case card
    case divider
    case barcode
}

protocol DataBlockViewModel {
    var type: DataBlockType { get }
}

extension BarcodeViewModel: DataBlockViewModel {
    var type: DataBlockType {
        .barcode
    }
}

extension DividerViewModel: DataBlockViewModel {
    var type: DataBlockType {
        .divider
    }
}

extension CardViewModel: DataBlockViewModel {
    var type: DataBlockType {
        .card
    }
}
