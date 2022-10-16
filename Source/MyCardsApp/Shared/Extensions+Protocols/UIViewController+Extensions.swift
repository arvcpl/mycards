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
    class func fromNib<T: UIViewController>() -> T {
        let nibName = String(describing: T.self)
        let viewController = UIViewController(nibName: nibName, bundle: Bundle.init(for: T.self))
        guard let viewController = viewController as? T else {
            fatalError("Unable load \(nibName)")
        }
        return viewController
    }
    
    var frameWidth: CGFloat {
        self.view.frame.size.width
    }
    
    var frameHeight: CGFloat {
        self.view.frame.size.height
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
