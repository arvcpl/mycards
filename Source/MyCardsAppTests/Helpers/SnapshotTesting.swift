/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import XCTest
import SnapshotTesting

protocol SnapshotTesting: XCTestCase {}

extension SnapshotTesting {

    private var testDevices: [Snapshotting<UIViewController, UIImage>] {
        return [
            .image(on: .iPhone13, precision: 0.99, traits: .init(userInterfaceStyle: .dark)),
            .image(on: .iPhone13, precision: 0.99, traits: .init(userInterfaceStyle: .light)),
            .image(on: .iPhoneSe, precision: 0.99, traits: .init(userInterfaceStyle: .dark)),
            .image(on: .iPhoneSe, precision: 0.99, traits: .init(userInterfaceStyle: .light))
        ]
    }

    func assertSnapshot(
        for viewController: UIViewController,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        testDevices.forEach { device in
            viewController.view.layoutIfNeeded()
            assertSnapshot(matching: viewController, as: device, record: recording,
                           file: file, testName: testName, line: line)
        }
    }

    func assertSnapshot<Value, Format>(
        matching value: @autoclosure () throws -> Value,
        as snapshotting: Snapshotting<Value, Format>,
        named name: String? = nil,
        record recording: Bool = false,
        timeout: TimeInterval = 5,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let snapshotDirectoryUrl = snapshotDirectory(for: file)
        let failure = verifySnapshot(
            matching: try value(),
            as: snapshotting,
            named: name,
            record: recording,
            snapshotDirectory: snapshotDirectoryUrl,
            timeout: timeout,
            file: file,
            testName: testName
        )
        guard let message = failure else { return }
        XCTFail("\(message) snap: \(snapshotDirectoryUrl) file: \(file) ", file: file, line: line)
    }

    private func snapshotDirectory(for file: StaticString, ciScriptsPathComponent: String = "ci_scripts") -> String {

        guard let productName = ProcessInfo.processInfo.environment["XCTestBundlePath"]?
            .components(separatedBy: "/").last?
            .components(separatedBy: ".").first else {
            fatalError("Can't extract product name")
        }

        var sourcePathComponents = URL(fileURLWithPath: "\(file)").pathComponents

        if let indexProductFolder = sourcePathComponents.firstIndex(of: productName) {
            sourcePathComponents[indexProductFolder] = ciScriptsPathComponent
            if let indexRepositoryFolder = sourcePathComponents.firstIndex(of: "repository"),
                (indexRepositoryFolder + 1) < indexProductFolder {
                sourcePathComponents.remove(atOffsets: IndexSet((indexRepositoryFolder+1)..<indexProductFolder))
            }
        }
        var pathsComponents: [String] = sourcePathComponents.dropLast()

        let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
        let folderName = fileUrl.deletingPathExtension().lastPathComponent

        pathsComponents.append("__Snapshots__")
        pathsComponents.append(folderName)

        return pathsComponents.joined(separator: "/")
    }
}
