/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class UIComposer {
    class func explainerTextView(title: String) -> UITextView {
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 0, right: 10)
        textView.font = UIFont.appFont(ofType: .regular, size: .medium)
        textView.text = title
        textView.textColor = UIColor.appTextOnDark
        textView.textAlignment = .left
        textView.backgroundColor = .black.withAlphaComponent(0.5)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
}
