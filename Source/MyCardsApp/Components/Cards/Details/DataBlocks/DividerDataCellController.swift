/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class DividerDataCellController: CellController {
    private let viewModel: DividerViewModel
    
    init(_ viewModel: DividerViewModel) {
        self.viewModel = viewModel
        super.init(id: UUID())
    }
    
    override func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: DividerDataTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.viewModel = viewModel
        return cell
    }
}
