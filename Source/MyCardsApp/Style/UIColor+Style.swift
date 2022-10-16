/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

extension UIColor {
    static let appText = UIColor(named: "clText")!
    static let appSearchPlaceholder = UIColor(named: "clSearchPlaceholder")!
    static let appHeader = UIColor(named: "clHeader")!
    static let appFail = UIColor(named: "clFail")!
    static let appSuccess = UIColor(named: "clSuccess")!
    static let appTextOnDark = UIColor(named: "clTextOnDark")!
    static let appAccent = UIColor(named: "clAccent")!
}

extension UIColor {
    var hexString: String {
        cgColor.components![0..<3]
            .map { String(format: "%02lX", Int($0 * 255)) }
            .reduce("#", +)
    }
    
    class var random: UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
    
    var complementary: UIColor {
        let ciColor = CIColor(color: self)

        // get the current values and make the difference from white:
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue

        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: ciColor.alpha)
    }

    var isDarkColor: Bool {
        var red, green, blue, alpha: CGFloat
        (red, green, blue, alpha) = (0, 0, 0, 0)
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let lum = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        return  lum < 0.50
    }
    
    var textColor: UIColor {
        let ciColor = CIColor(color: self)
        
        let compRed: CGFloat = ciColor.red * 0.299
        let compGreen: CGFloat = ciColor.green * 0.587
        let compBlue: CGFloat = ciColor.blue * 0.114

        let luminance = (compRed + compGreen + compBlue)

        return luminance < 0.55 ? maxBright() : minBright()
    }
    
    var gradientStart: UIColor {
        return delta(0.2)
    }
    
    var gradientEnd: UIColor {
        return delta(-0.2)
    }
    
    func maxBright() -> UIColor {
        return delta(0.5)
    }
    
    func minBright() -> UIColor {
        return delta(-0.5)
    }
    
    private func delta(_ delta: CGFloat) -> UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: red + delta, green: green + delta, blue: blue + delta, alpha: 1.0)
        }
        return self
    }
}
