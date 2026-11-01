@testable import G2Core
import ImageIO
import UIKit
import UniformTypeIdentifiers
import XCTest

@MainActor
final class StorageAndImageTests: XCTestCase {
    var root: URL!

    override func setUpWithError() throws {
        root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        try FileManager.default.removeItem(at: root)
    }

    func source(width: Int = 800, height: Int = 600, orientation: Int = 1) throws -> Data {
        let format = UIGraphicsImageRendererFormat(); format.scale = 1
        let image = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: format)
            .image { context in
                UIColor.red.setFill()
                context.fill(CGRect(x: 0, y: 0, width: width / 2, height: height))
                UIColor.blue.setFill()
                context.fill(CGRect(x: width / 2, y: 0, width: width / 2, height: height))
            }
        let data = NSMutableData()
        let destination = try XCTUnwrap(CGImageDestinationCreateWithData(
            data,
            UTType.jpeg.identifier as CFString,
            1,
            nil
        ))
        try CGImageDestinationAddImage(destination, XCTUnwrap(image.cgImage), [
            kCGImagePropertyOrientation: orientation,
            kCGImagePropertyGPSDictionary: [
                kCGImagePropertyGPSLatitude: 0.01,
                kCGImagePropertyGPSLatitudeRef: "N",
                kCGImagePropertyGPSLongitude: 0.01,
                kCGImagePropertyGPSLongitudeRef: "E",
                kCGImagePropertyGPSHPositioningError: 12,
            ],
            kCGImagePropertyExifDictionary: [kCGImagePropertyExifDateTimeOriginal: "2026:10:31 09:15:00"],
        ] as CFDictionary)
        XCTAssertTrue(CGImageDestinationFinalize(destination))
        return data as Data
    }

    func testDecodedOutputsAreSquareBoundedAndStripGPSForEveryOrientation() throws {
        for orientation in 1 ... 8 {
            let result = try ImagePipeline.process(source: source(width: 2400, height: 1600, orientation: orientation))
            for (bytes, limit) in [(result.main, 2048), (result.thumbnail, 400)] {
                let image = try XCTUnwrap(CGImageSourceCreateWithData(bytes as CFData, nil))
                let decoded = try XCTUnwrap(CGImageSourceCreateImageAtIndex(image, 0, nil))
                XCTAssertEqual(decoded.width, decoded.height)
                XCTAssertLessThanOrEqual(decoded.width, limit)
                let properties = CGImageSourceCopyPropertiesAtIndex(image, 0, nil) as? [CFString: Any]
                XCTAssertNil(properties?[kCGImagePropertyGPSDictionary])
            }
        }
    }

    func testSmallImageIsNotUpscaledAndCorruptInputFails() throws {
        let result = try ImagePipeline.process(source: source(width: 80, height: 60))
        let image = try XCTUnwrap(CGImageSourceCreateWithData(result.main as CFData, nil))
        XCTAssertEqual(CGImageSourceCreateImageAtIndex(image, 0, nil)?.width, 60)
        XCTAssertThrowsError(try ImagePipeline.process(source: Data([0, 1, 2])))
    }

    func testMetadataDetectsSourceGPSWithoutLoggingOrCopyingToOutput() throws {
        let input = try source()
        let metadata = try ImagePipeline.inspect(input)
        XCTAssertTrue(metadata.hasGPS)
        XCTAssertEqual(metadata.gpsAccuracy, 12)
        XCTAssertNotNil(metadata.capturedAt)
        let result = try ImagePipeline.process(source: input)
        XCTAssertFalse(try ImagePipeline.inspect(result.main).hasGPS)
        XCTAssertNil(try ImagePipeline.inspect(result.main).capturedAt)
    }

    func testCenterCropMatchesIndependentUIKitOrientationReference() throws {
        func pixels(_ image: UIImage, side: Int) throws -> [UInt8] {
            let format = UIGraphicsImageRendererFormat(); format.scale = 1
            let normalized = UIGraphicsImageRenderer(size: CGSize(width: side, height: side), format: format)
                .image { _ in
                    let oriented = image.size
                    image.draw(in: CGRect(
                        x: (CGFloat(side) - oriented.width) / 2,
                        y: (CGFloat(side) - oriented.height) / 2,
                        width: oriented.width,
                        height: oriented.height
                    ))
                }
            var bytes = [UInt8](repeating: 0, count: side * side * 4)
            let context = try XCTUnwrap(CGContext(
                data: &bytes,
                width: side,
                height: side,
                bitsPerComponent: 8,
                bytesPerRow: side * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ))
            try context.draw(XCTUnwrap(normalized.cgImage), in: CGRect(x: 0, y: 0, width: side, height: side))
            return bytes
        }
        for orientation in 1 ... 8 {
            let input = try source(width: 80, height: 60, orientation: orientation)
            let expected = try pixels(XCTUnwrap(UIImage(data: input)), side: 60)
            let actual = try pixels(XCTUnwrap(UIImage(data: ImagePipeline.process(source: input).main)), side: 60)
            for point in [(15, 15), (45, 15), (15, 45), (45, 45)] {
                let offset = (point.1 * 60 + point.0) * 4
                for channel in 0 ..< 3 {
                    XCTAssertLessThan(
                        abs(Int(expected[offset + channel]) - Int(actual[offset + channel])),
                        20,
                        "orientation \(orientation)"
                    )
                }
            }
        }
    }

    func testCurrentHideDoesNotReopenAnOldPlaceAndSourceSurvivesStateChange() throws {
        let store = try DraftStore(root: root, accountID: "fixture-a")
        let id = try store.capture(source: source(), origin: "fixture", capturedAt: nil)
        try store.complete(id, output: ImagePipeline.process(source: source()))
        try store.update(id, title: String(repeating: "a", count: 121), hidden: false)
        XCTAssertEqual(try store.list().first?.title.count, 120)
        try store.attach(id, placeID: "fixture-garden")
        try store.markProcessingFailed(id)
        XCTAssertEqual(try store.list().first?.state, "processingFailed")
        XCTAssertEqual(try store.list().first?.placeID, "fixture-garden")
        XCTAssertTrue(FileManager.default.fileExists(atPath: store.sourceURL(id).path))
    }

    func testSourceAndDraftRecoverAfterReopeningAndAreAccountPartitioned() throws {
        let input = try source()
        var store: DraftStore? = try DraftStore(root: root, accountID: "fixture-a")
        let id = try XCTUnwrap(try store?.capture(source: input, origin: "fixture", capturedAt: nil))
        XCTAssertEqual(try Data(contentsOf: XCTUnwrap(store?.sourceURL(id))), input)
        store = nil
        let reopened = try DraftStore(root: root, accountID: "fixture-a")
        XCTAssertEqual(try reopened.list().map(\.id), [id])
        let other = try DraftStore(root: root, accountID: "fixture-b")
        XCTAssertTrue(try other.list().isEmpty)
        XCTAssertThrowsError(try other.process(id))
    }

    func testProcessingFailureKeepsOriginalAndSameDraftIDForRetry() throws {
        let store = try DraftStore(root: root, accountID: "fixture-a")
        let id = try store.capture(source: Data([0, 1]), origin: "fixture-corrupt", capturedAt: nil)
        XCTAssertThrowsError(try store.process(id))
        XCTAssertTrue(FileManager.default.fileExists(atPath: store.sourceURL(id).path))
        XCTAssertEqual(try store.list().count, 1)
        XCTAssertEqual(try store.list().first?.state, "processingFailed")
    }

    func testInboxRequiresOwnerDeduplicatesAndRejectsStaleEpoch() throws {
        let inbox = try ShareInbox(root: root)
        XCTAssertThrowsError(try inbox.append(text: "https://example.com/post", owner: nil))
        let owner = InboxOwner(accountID: "fixture-a", epoch: UUID())
        try inbox.setOwner(owner)
        let first = try inbox.append(
            text: "Look https://example.com/post?utm_source=test",
            owner: owner,
            types: ["public.plain-text"]
        )
        let second = try inbox.append(text: "https://example.com/post", owner: owner)
        XCTAssertEqual(first.item.id, second.item.id)
        XCTAssertFalse(first.duplicate)
        XCTAssertTrue(second.duplicate)
        XCTAssertEqual(try inbox.items(for: owner.accountID).first?.receivedTypes, ["public.plain-text"])
        XCTAssertEqual(try inbox.items(for: owner.accountID).count, 1)
        try inbox.setOwner(InboxOwner(accountID: "fixture-b", epoch: UUID()))
        XCTAssertThrowsError(try inbox.append(text: "https://example.com/other", owner: owner))
        XCTAssertTrue(try inbox.items(for: "fixture-b").isEmpty)
    }

    func testShareParserRejectsUnsupportedSchemesAndKeepsPendingIntent() throws {
        XCTAssertThrowsError(try SharePayload.parse("javascript:alert(1)"))
        XCTAssertThrowsError(try SharePayload.parse("http://example.com"))
        let payload = try SharePayload.parse("A place https://www.instagram.com/p/fixture/?utm_medium=share")
        XCTAssertEqual(payload.url.host, "www.instagram.com")
        XCTAssertFalse(payload.canonicalURL.contains("utm_medium"))
    }
}
