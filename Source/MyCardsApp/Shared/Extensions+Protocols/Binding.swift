/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

protocol Bindable {
    func bind()
    func unbind()
}

typealias VarUpdateTask = Task<Void, Never>

extension Array where Element == VarUpdateTask {
    mutating func unbind() {
        for task in self {
            task.cancel()
        }
        removeAll()
    }
}

extension Bindable where Self: UIViewController {
    
    func bind() {}
    func unbind() {}
    
    func bindAll(extraViews: [Bindable]? = .none) {
        view.subviews
            .compactMap({ $0 as? Bindable })
            .forEach({ $0.bind() })
        if let extraViews = extraViews {
            extraViews.forEach({ $0.bind() })
        }
        bind()
    }
    
    func unbindAll(extraViews: [Bindable]? = .none) {
        view.subviews
            .compactMap({ $0 as? Bindable })
            .forEach({ $0.unbind() })
        if let extraViews = extraViews {
            extraViews.forEach({ $0.unbind() })
        }
        unbind()
    }
}
