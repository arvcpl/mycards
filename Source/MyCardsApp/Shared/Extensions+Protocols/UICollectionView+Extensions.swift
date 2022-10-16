/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

extension UICollectionView {
    func dequeueReusableSupplementaryView<T: UICollectionReusableView & IdentifiableView>(for indexPath: IndexPath) -> T {
        let supplementaryView = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                      withReuseIdentifier: T.identifier,
                                                                      for: indexPath)
        guard let view = supplementaryView as? T else {
            fatalError("Unable to cast supplementary view: [\(String(describing: supplementaryView))] to type: [\(T.self)]")
        }
        return view
    }
        
    func dequeueReusableCell<T: UICollectionViewCell & IdentifiableView>(for indexPath: IndexPath) -> T {
        let collectionViewCell = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath)
        guard let cell = collectionViewCell as? T else {
            fatalError("Unable to cast cell: [\(String(describing: collectionViewCell))] to type: [\(T.self)]")
        }
        return cell
    }
    
    func register(_ cellClass: IdentifiableView.Type, isNib: Bool = false) {
        if isNib {
            let nibName = cellClass.identifier
            let bundle = Bundle(for: cellClass.self)
            let nib = UINib.init(nibName: nibName, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: cellClass.identifier)
        } else {
            register(cellClass.self, forCellWithReuseIdentifier: cellClass.identifier)
        }
    }
    
    func registerHeader(_ headerClass: IdentifiableView.Type) {
        register(headerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerClass.identifier)
    }
}
