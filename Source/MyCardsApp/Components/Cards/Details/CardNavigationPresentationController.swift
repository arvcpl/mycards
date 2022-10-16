/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class CardNavigationPresentationController: UIPresentationController {

    private lazy var dimmingView: UIView = {
        let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        return dimmingView
    }()

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        let superview = presentingViewController.view!
        superview.addSubview(dimmingView)
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            dimmingView.topAnchor.constraint(equalTo: superview.topAnchor)
        ])

        dimmingView.alpha = 0
        guard let cardViewController = cardDetailsViewController() else { return }
        cardViewController.view.layoutIfNeeded() // update needed for correct animations, causes UITableViewAlertForLayoutOutsideViewHierarchy though
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
            cardViewController.animateTransitionsStart()
        }, completion: { _ in
            cardViewController.animateTransitionsStartEnd()
        })
    }
    
    private func cardDetailsViewController() -> CardDetailsViewController? {
        let navigationController = presentedViewController as? UINavigationController
        return navigationController?.topViewController as? CardDetailsViewController
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let cardViewController = cardDetailsViewController() else { return }
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
            cardViewController.hideNavigationHeader()
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }
}
