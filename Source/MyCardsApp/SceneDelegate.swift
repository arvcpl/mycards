/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        configure()
        let cardsViewModel = CardsViewModel()
        let cardsViewController = CardsViewController(viewModel: cardsViewModel)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: cardsViewController)
        self.window = window
        window.makeKeyAndVisible()
        
        if let url = connectionOptions.urlContexts.first?.url {
            let cardId = url.lastPathComponent
            showCard(by: cardId)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            let cardId = url.lastPathComponent
            showCard(by: cardId)
        }
    }
    
    private func configure() {
        UITextField.appearance().tintColor = .appAccent
        UIBarButtonItem.appearance().tintColor = .appAccent
        UITabBar.appearance().tintColor = .appAccent
        UITabBar.appearance().unselectedItemTintColor = .appText
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.appFont(ofType: .medium, size: .smaller)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.appFont(ofType: .medium, size: .smaller)], for: .selected)
    }
    
    private func showCard(by uuid: String) {
        guard let cardViewModel = CardsStore.load(by: uuid) else { return }
        guard let navigationController = window?.rootViewController as? UINavigationController else { return }
        if let currentlyLoadedCardNavigationController = navigationController.presentedViewController as? CardNavigationController {
            let cardDetailsViewModel = CardDetailsViewModel(cardViewModel: cardViewModel.adjust(viewState: .large), showViewOnInit: true)
            let cardViewController = CardDetailsViewController(viewModel: cardDetailsViewModel)
            currentlyLoadedCardNavigationController.setViewControllers([cardViewController], animated: false)
        } else {
            let cardDetailsViewModel = CardDetailsViewModel(cardViewModel: cardViewModel)
            let cardViewController = CardDetailsViewController(viewModel: cardDetailsViewModel)
            let cardNavigationController = CardNavigationController(rootViewController: cardViewController)
            navigationController.present(cardNavigationController, animated: false)
        }
    }
}
