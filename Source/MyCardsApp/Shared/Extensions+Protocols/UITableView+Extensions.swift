/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell & IdentifiableView>(for indexPath: IndexPath) -> T {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath)
        guard let cell = tableViewCell as? T else {
            fatalError("Unable to cast cell: [\(String(describing: tableViewCell))] to type: [\(T.self)]")
        }
        return cell
    }
    
    func register(_ cellClass: IdentifiableView.Type, isNib: Bool = false) {
        if isNib {
            let nibName = cellClass.identifier
            let bundle = Bundle(for: cellClass.self)
            let nib = UINib.init(nibName: nibName, bundle: bundle)
            register(nib, forCellReuseIdentifier: cellClass.identifier)
        } else {
            register(cellClass.self, forCellReuseIdentifier: cellClass.identifier)
        }
    }
}
