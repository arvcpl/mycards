/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import UIKit

struct CardsStore {
    
    @MainActor
    static var recentCards = [
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E51")!, name: "ACIU", barcode: "D664479543434111", barcodeType: .code128, color: .orange, backgroundType: .image,
                          backgroundImage: UIImage(named: "card_aciu"), recent: true, viewState: .small),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E52")!, name: "IKI", barcode: "9989061117111", barcodeType: .code128, color: .green, backgroundType: .color,
                                       recent: true, viewState: .small),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E53")!, name: "BENU", barcode: "BENU010635111", barcodeType: .code128, color: .darkGray, backgroundType: .color,
                                       recent: true, viewState: .small),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E54")!, name: "VERO", barcode: "682665111", barcodeType: .code128, color: .brown, backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_vero"),
                                       recent: true, viewState: .small),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E55")!, name: "LIDL", barcode: "77700005493524111", barcodeType: .qr, color: .blue, backgroundType: .color, recent: true, viewState: .small),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E56")!, name: "ERMITAZAS",
                                       barcode: "L0040618111",
                          barcodeType: .code128, color: .orange, backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_ermitazas"),
                                       recent: true, viewState: .small)
    ]
    private static let euPassQRCode = "HC1:NCFOXNYTSFDHJI89.O/99Y1L9BQM/IFI1OA3I:IW-4%YGC89V+99IU:X95MPN5ECV4*XUA2P-FHT-HNTI4L6N$Q%UG/YL WO*Z7ON1.-LDJ8PN17XHWVHRO1DE0+"
        + "FGI8.F02E42U3LO8F$B:PICIAKSJDKLASHDJKASHDJKHASKJ DHJKSDH JKASHDKJHSDKJHASHDKJASLHD "
        + "N4AQHT1I7CQ-8QNG6S84*W6ISLDKA:LSDK LAJDSLKSAJKLDJ ALSKDJLAKSJDL KAJSDKLJKLSADJ LKSAAQJKPHNKERT+4IGF5JNBPI$RU.8ITAFHZ0ROFJ47"
        + " /K:*K4$0U 8W3SAL:SKD:LSKD:LASKD:LAKS:D:LSADSDAS+Y8MDTTRB4"
        + "68.PUVRBCJ%0GTHJBMCEASKLKAS:DK:ALSKLSAKDSLKD:LS:D:LDS%NOFWX6SC3H5TDO%VA:S8Z358OTCMTXV+NLRTMO:LB/I9F7/:K5RNLSH1QC82J%SF0.TD"
        + "T0CRD:CLCTJZ43F11BE94UNPSOCV85E5+ORB51.1ZDIZ429+2VGMY0OH6852W1.IP.IDKEFBWXRBGC5-SE3VTOOJZ*HI41W7AL47HU2-MU%FCUQSU+958M4S7SWOWY44:C0ZP.JRT8FKJUI-0QOS$:4E4C:IFD7NOWB0KKEX5BRN21S465X6U+E1B%2FASMNJF+156DC%T"
    
    @MainActor
    static var myCards = [
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E51")!, name: "EU PASS", barcode: euPassQRCode, barcodeType: .qr, color: .blue, backgroundType: .color,
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E52")!, name: "IKI", barcode: "9989061117111", barcodeType: .code128, color: .green, backgroundType: .color,
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E53")!, name: "BENU", barcode: "BENU010635111", barcodeType: .code128, color: .darkGray, backgroundType: .color,
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E54")!, name: "VERO", barcode: "682665111", barcodeType: .code128, color: .brown, backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_vero"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E55")!, name: "LIDL", barcode: "77700005493524111", barcodeType: .qr, color: .blue, backgroundType: .color, recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E56")!, name: "ERMITAZAS",
                                       barcode: "L0040618111",
                          barcodeType: .code128, color: .orange,
                                       backgroundImageUrl: "https://www.ermitazas.lt/out/pictures/wysiwigpro/CLASSIC_priekis.png", backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_ermitazas"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E51")!, name: "ACIU", barcode: "D664479543434111", barcodeType: .code128, color: .orange, backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_aciu"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E52")!, name: "IKI", barcode: "9989061117111", barcodeType: .code128, color: .green, backgroundType: .color,
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E53")!, name: "BENU", barcode: "BENU010635111", barcodeType: .code128, color: .darkGray, backgroundType: .color,
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E54")!, name: "VERO", barcode: "682665111", barcodeType: .code128, color: .brown, backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_vero"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E55")!, name: "LIDL", barcode: "77700005493524111", barcodeType: .qr, color: .blue, backgroundType: .color, recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E56")!, name: "ERMITAZAS",
                                       barcode: "L0040618111",
                          barcodeType: .code128, color: .orange,
                          backgroundImageUrl: "https://www.ermitazas.lt/out/pictures/wysiwigpro/CLASSIC_priekis.png", backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_ermitazas"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E51")!, name: "ACIU", barcode: "D664479543434111", barcodeType: .code128, color: .orange, backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_aciu"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E52")!, name: "IKI", barcode: "9989061117111", barcodeType: .code128, color: .green, backgroundType: .color,
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E53")!, name: "BENU", barcode: "BENU010635111", barcodeType: .code128, color: .darkGray, backgroundType: .color,
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E54")!, name: "VERO", barcode: "682665111", barcodeType: .code128, color: .brown, backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_vero"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E55")!, name: "LIDL", barcode: "77700005493524111", barcodeType: .qr, color: .blue, backgroundType: .color, recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E56")!, name: "ERMITAZAS",
                                       barcode: "L0040618111",
                          barcodeType: .code128, color: .orange,
                          backgroundImageUrl: "https://www.ermitazas.lt/out/pictures/wysiwigpro/CLASSIC_priekis.png", backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_ermitazas"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E51")!, name: "ACIU", barcode: "D664479543434111", barcodeType: .code128, color: .orange, backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_aciu"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E52")!, name: "IKI", barcode: "9989061117111", barcodeType: .code128, color: .green, backgroundType: .color,
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E53")!, name: "BENU", barcode: "BENU010635111", barcodeType: .code128, color: .darkGray, backgroundType: .color,
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E54")!, name: "VERO", barcode: "682665111", barcodeType: .code128, color: .brown, backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_vero"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E55")!, name: "LIDL", barcode: "77700005493524111", barcodeType: .qr, color: .blue, backgroundType: .color, recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E56")!, name: "ERMITAZAS",
                                       barcode: "L0040618111",
                          barcodeType: .code128, color: .orange,
                          backgroundImageUrl: "https://www.ermitazas.lt/out/pictures/wysiwigpro/CLASSIC_priekis.png", backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_ermitazas"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E51")!, name: "ACIU", barcode: "D664479543434111", barcodeType: .code128, color: .orange,
                          backgroundType: .image, backgroundImage: UIImage(named: "card_aciu"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E52")!, name: "IKI", barcode: "9989061117111", barcodeType: .code128, color: .green, backgroundType: .color,
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E53")!, name: "BENU", barcode: "BENU010635111", barcodeType: .code128, color: .darkGray, backgroundType: .color,
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E54")!, name: "VERO", barcode: "682665111", barcodeType: .code128, color: .brown,
                          backgroundType: .image, backgroundImage: UIImage(named: "card_vero"),
                                       recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E55")!, name: "LIDL", barcode: "77700005493524111", barcodeType: .qr, color: .blue, backgroundType: .color, recent: false, viewState: .regular),
        CardViewModel(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E56")!, name: "ERMITAZAS",
                                       barcode: "L0040618111",
                          barcodeType: .code128, color: .orange,
                          backgroundImageUrl: "https://www.ermitazas.lt/out/pictures/wysiwigpro/CLASSIC_priekis.png", backgroundType: .image,
                                       backgroundImage: UIImage(named: "card_ermitazas"),
                                       recent: false, viewState: .regular)
    ]
    
    @MainActor
    static func store(name: String, barcode: String, barcodeType: BarcodeType, color: UIColor?, image: UIImage?, backgroundType: CardViewModel.Background) {
        let viewModel = CardViewModel(id: UUID(),
                                      name: name,
                                      barcode: barcode,
                                      barcodeType: barcodeType,
                                      color: color,
                                      backgroundType: backgroundType,
                                      backgroundImage: image,
                                      recent: true,
                                      viewState: .regular)
        if myCards.count > 0 {
            myCards.insert(viewModel, at: 0)
        } else {
            myCards.append(viewModel)
        }
    }
    
    @MainActor
    static func load(by uuid: String) -> CardViewModel? {
        return recentCards.filter({ $0.id.uuidString == uuid }).first
    }
}
