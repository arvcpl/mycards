/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class CellController: Hashable {
    private let id: AnyHashable
    
    init(id: AnyHashable) {
        self.id = id
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        fatalError("Implement Me")
    }
    
    static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
