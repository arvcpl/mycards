/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

struct CardStyle {
    static let cornerRadiusSmall: CGFloat = 5
    static let cornerRadiusRegular: CGFloat = 6
    static let cornerRadiusLarge: CGFloat = 10
    
    static func cardHeight(for width: CGFloat) -> CGFloat {
        return width * 54.0 / 86.0
    }
}
