/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

extension UIViewController {
    var frameWidth: CGFloat {
        self.view.frame.size.width
    }
    
    var frameHeight: CGFloat {
        self.view.frame.size.height
    }

    func setTitleView(_ titleView: UIView) {
        navigationItem.titleView = titleView
        let headerHeightConstraint = titleView.heightAnchor.constraint(equalToConstant: 100)
        headerHeightConstraint.priority = .defaultHigh
        let headerWidthConstraint = titleView.widthAnchor.constraint(equalToConstant: 500)
        headerWidthConstraint.priority = .dragThatCanResizeScene
        NSLayoutConstraint.activate([headerHeightConstraint, headerWidthConstraint])
    }
    
    func add(_ child: UIViewController, frame: CGRect? = nil, insertAtBottom: Bool = true) {
        addChild(child)

        if let frame = frame {
            child.view.frame = frame
        } else {
            child.view.frame = view.frame
        }

        if view.subviews.count > 0 && insertAtBottom {
            view.insertSubview(child.view, at: 0)
        } else {
            view.addSubview(child.view)
        }
        child.didMove(toParent: self)
    }

    @objc func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func removeChildren() {
        for child in children {
            child.remove()
        }
    }
}
