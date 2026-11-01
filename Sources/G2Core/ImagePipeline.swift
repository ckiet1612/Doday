import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

public enum G2Error: Error { case invalidImage, tooLarge, storage, noAccount, staleOwner, invalidURL, liveLocked,
                                  unavailable
}

public struct ImageMetadata {
    public let width: Int
    public let height: Int
    public let hasGPS: Bool
    public let coordinate: Coordinate?
    public let gpsAccuracy: Double?
    public let capturedAt: Date?
}

public struct ProcessedImage { public let main: Data; public let thumbnail: Data }
public enum ImagePipeline {
    public static func inspect(_ bytes: Data) throws -> ImageMetadata {
        guard let source = CGImageSourceCreateWithData(bytes as CFData, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let width = properties[kCGImagePropertyPixelWidth] as? Int,
              let height = properties[kCGImagePropertyPixelHeight] as? Int else { throw G2Error.invalidImage }
        let gps = properties[kCGImagePropertyGPSDictionary] as? [CFString: Any]
        var coordinate: Coordinate?
        if let latitude = gps?[kCGImagePropertyGPSLatitude] as? Double,
           let longitude = gps?[kCGImagePropertyGPSLongitude] as? Double
        {
            let candidate = Coordinate(
                latitude: latitude * ((gps?[kCGImagePropertyGPSLatitudeRef] as? String) == "S" ? -1 : 1),
                longitude: longitude * ((gps?[kCGImagePropertyGPSLongitudeRef] as? String) == "W" ? -1 : 1)
            )
            if candidate.isValid {
                coordinate = candidate
            }
        }
        let accuracy = (gps?[kCGImagePropertyGPSHPositioningError] as? Double)
            .flatMap { $0.isFinite && $0 >= 0 ? $0 : nil }
        // EXIF dates carry no zone; read in the device zone and label the result as the photo's own capture time.
        let exif = properties[kCGImagePropertyExifDictionary] as? [CFString: Any]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX"); formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        let capturedAt = (exif?[kCGImagePropertyExifDateTimeOriginal] as? String).flatMap(formatter.date(from:))
        return ImageMetadata(
            width: width,
            height: height,
            hasGPS: gps != nil,
            coordinate: coordinate,
            gpsAccuracy: accuracy,
            capturedAt: capturedAt
        )
    }

    public static func process(source bytes: Data) throws -> ProcessedImage {
        let metadata = try inspect(bytes)
        guard bytes.count <= 20 * 1024 * 1024, metadata.width > 0, metadata.height > 0,
              Double(metadata.width) * Double(metadata.height) <= 100_000_000 else { throw G2Error.tooLarge }
        guard let source = CGImageSourceCreateWithData(bytes as CFData, nil),
              let normalized = CGImageSourceCreateThumbnailAtIndex(source, 0, [
                  kCGImageSourceCreateThumbnailFromImageAlways: true,
                  kCGImageSourceCreateThumbnailWithTransform: true,
                  kCGImageSourceThumbnailMaxPixelSize: max(metadata.width, metadata.height),
              ] as CFDictionary) else { throw G2Error.invalidImage }
        let side = min(normalized.width, normalized.height)
        let rect = CGRect(
            x: (normalized.width - side) / 2,
            y: (normalized.height - side) / 2,
            width: side,
            height: side
        )
        guard let square = normalized.cropping(to: rect) else { throw G2Error.invalidImage }
        return try ProcessedImage(
            main: encode(square, size: min(side, 2048)),
            thumbnail: encode(square, size: min(side, 400))
        )
    }

    private static func encode(_ image: CGImage, size: Int) throws -> Data {
        guard let context = CGContext(
            data: nil,
            width: size,
            height: size,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        )
        else { throw G2Error.invalidImage }
        context.interpolationQuality = .high
        context.draw(image, in: CGRect(x: 0, y: 0, width: size, height: size))
        let bytes = NSMutableData()
        guard let output = context.makeImage(),
              let destination = CGImageDestinationCreateWithData(bytes, UTType.jpeg.identifier as CFString, 1, nil)
        else { throw G2Error.invalidImage }
        // Fresh encoding deliberately copies no source metadata. JPEG/0.85 is a G2 probe, not G4's codec decision.
        CGImageDestinationAddImage(destination, output, [
            kCGImageDestinationLossyCompressionQuality: 0.85,
            kCGImagePropertyOrientation: 1,
        ] as CFDictionary)
        guard CGImageDestinationFinalize(destination) else { throw G2Error.invalidImage }
        return bytes as Data
    }
}
