/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

class BarcodeViewModel {
    let barcode: String
    let barcodeType: BarcodeType
    
    init(barcode: String, type: BarcodeType) {
        self.barcode = barcode
        self.barcodeType = type
    }
    
    var isQRBig: Bool {
        return barcode.count > 40
    }
    
    var barcodeText: NSAttributedString {
        return NSAttributedString(string: barcode, attributes: [NSAttributedString.Key.kern: 1.15])
    }
    
    var barcodeImage: UIImage? {
        let data = barcode.data(using: String.Encoding.ascii)
        var filterName = "CICode128BarcodeGenerator"
        var scaleX = 3.0
        if barcodeType == .qr {
            filterName = "CIQRCodeGenerator"
            scaleX = 5.0
        }
        let context = CIContext()
        if let filter = CIFilter(name: filterName) {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: scaleX, y: 5)
            if let qrCodeImage = filter.outputImage?.transformed(by: transform) {
                if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                    return UIImage(cgImage: qrCodeCGImage)
                }
            }
        }
        return nil
    }
}
