/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

enum FontType: String {
    case regular = "Montserrat-Regular"
    case medium = "Montserrat-Medium"
    case bold = "Montserrat-Bold"
}

enum FontSize: CGFloat {
    case viewHeader = 18
    case large = 16
    case medium = 14
    case regular = 12
    case small = 10
    case smaller = 9
    case tiny = 7
}

extension UIFont {
    static func appFont(ofType type: FontType, size: FontSize) -> UIFont {
        return UIFont(name: type.rawValue, size: size.rawValue)!
    }
}
