/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

enum BarcodeType {
    case code128, qr
}

@MainActor
class CardViewModel: ObservableObject, Identifiable {
    
    enum State {
        case small, regular, large
    }
    
    enum Background {
        case color, image
    }
    
    static let empty = CardViewModel(id: UUID(), name: "", barcode: "", barcodeType: .code128, color: .white, backgroundImageUrl: nil, backgroundType: .color, recent: false, viewState: .regular)
    
    let id: UUID
    let name: String
    let barcode: String
    let barcodeType: BarcodeType
    let color: UIColor?
    let backgroundImageUrl: String?
    let backgroundType: Background
    let recent: Bool
    let viewState: State
    
    @Published fileprivate(set) var backgroundImage: UIImage?
    
    init(id: UUID, name: String,
         barcode: String, barcodeType: BarcodeType = .code128,
         color: UIColor?,
         backgroundImageUrl: String? = nil,
         backgroundType: Background,
         backgroundImage: UIImage? = nil,
         recent: Bool,
         viewState: State) {
        self.id = id
        self.name = name
        self.barcode = barcode
        self.barcodeType = barcodeType
        self.backgroundImage = backgroundImage
        self.color = color
        self.backgroundImageUrl = backgroundImageUrl
        self.backgroundType = backgroundType
        self.recent = recent
        self.viewState = viewState
    }
    
    func loadBackgroundImage() {
    }
    
    @MainActor
    func adjust(viewState newViewState: State?) -> CardViewModel {
        let adjustedModel = CardViewModel(id: id, name: name,
                                          barcode: barcode, barcodeType: barcodeType,
                                          color: color, backgroundImageUrl: backgroundImageUrl,
                                          backgroundType: backgroundType,
                                          backgroundImage: backgroundImage,
                                          recent: recent,
                                          viewState: newViewState ?? viewState)
        return adjustedModel
    }
}
