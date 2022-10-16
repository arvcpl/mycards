/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

extension UIComposer {
    class func buttonVerticalWithImageAndTitle(imageSystemName: String,
                                               title: String,
                                               config: UIButton.Configuration = UIButton.Configuration.borderless(),
                                               primaryAction: UIAction) -> UIButton {
        var buttonConfig = config
        let imageConfig = UIImage.SymbolConfiguration(weight: .bold)
        var container = AttributeContainer()
        container.font = UIFont.appFont(ofType: .regular, size: .small)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        container.paragraphStyle = paragraph
        buttonConfig.attributedTitle = AttributedString(title, attributes: container)
        buttonConfig.imagePadding = 6
        buttonConfig.image = UIImage(systemName: imageSystemName, withConfiguration: imageConfig)
        buttonConfig.imagePlacement = .top
        let button = UIButton(configuration: buttonConfig, primaryAction: primaryAction)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    class func buttonActionWithTitle(title: String, config: UIButton.Configuration = UIButton.Configuration.borderless(), primaryAction: UIAction) -> UIButton {
        var buttonConfig = config
        var container = AttributeContainer()
        container.font = UIFont.appFont(ofType: .bold, size: .regular)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        container.paragraphStyle = paragraph
        buttonConfig.attributedTitle = AttributedString(title, attributes: container)
        let button = UIButton(configuration: buttonConfig, primaryAction: primaryAction)
        button.backgroundColor = .appAccent
        button.tintColor = .white
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    class func buttonSecondaryWithTitle(title: String, config: UIButton.Configuration = UIButton.Configuration.borderless(), primaryAction: UIAction) -> UIButton {
        var buttonConfig = config
        var container = AttributeContainer()
        container.font = UIFont.appFont(ofType: .bold, size: .regular)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        container.paragraphStyle = paragraph
        buttonConfig.attributedTitle = AttributedString(title, attributes: container)
        let button = UIButton(configuration: buttonConfig, primaryAction: primaryAction)
        button.tintColor = .appAccent
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
