import G2Core
import ImageIO
import UIKit

// User-facing copy and the synthetic fixture image, kept apart from AppModel's state handling.
extension AppModel {
    static func fixtureImage(gps: Coordinate? = nil) -> Data {
        let format = UIGraphicsImageRendererFormat(); format.scale = 1
        let image = UIGraphicsImageRenderer(size: CGSize(width: 960, height: 720), format: format).image { context in
            UIColor(red: 0.80, green: 0.90, blue: 0.89, alpha: 1).setFill(); context.fill(CGRect(
                x: 0,
                y: 0,
                width: 960,
                height: 720
            ))
            UIColor(red: 0.19, green: 0.40, blue: 0.30, alpha: 1).setFill(); context.fill(CGRect(
                x: 0,
                y: 370,
                width: 960,
                height: 350
            ))
            UIColor(red: 0.93, green: 0.76, blue: 0.40, alpha: 1).setFill(); context.fill(CGRect(
                x: 400,
                y: 290,
                width: 160,
                height: 430
            ))
            for treeX in [180, 320, 690, 820] {
                UIColor(red: 0.1, green: 0.29, blue: 0.24, alpha: 1).setFill()
                context.cgContext.fillEllipse(in: CGRect(x: treeX - 90, y: 120, width: 180, height: 300))
            }
            let words = "DODAY / FIXTURE"
            words.draw(
                at: CGPoint(x: 285, y: 70),
                withAttributes: [
                    .font: UIFont.monospacedSystemFont(ofSize: 36, weight: .semibold),
                    .foregroundColor: UIColor.black,
                ]
            )
        }
        guard let gps, let cgImage = image.cgImage else { return image.jpegData(compressionQuality: 0.9)! }
        // Synthetic canary EXIF only, so the B3 path can be exercised without anyone's real location.
        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, "public.jpeg" as CFString, 1, nil)
        else { return image.jpegData(compressionQuality: 0.9)! }
        CGImageDestinationAddImage(destination, cgImage, [
            kCGImagePropertyGPSDictionary: [
                kCGImagePropertyGPSLatitude: abs(gps.latitude),
                kCGImagePropertyGPSLatitudeRef: gps.latitude < 0 ? "S" : "N",
                kCGImagePropertyGPSLongitude: abs(gps.longitude),
                kCGImagePropertyGPSLongitudeRef: gps.longitude < 0 ? "W" : "E",
                kCGImagePropertyGPSHPositioningError: 10,
            ],
        ] as CFDictionary)
        CGImageDestinationFinalize(destination)
        return data as Data
    }

    func gateText(_ result: GateResult?) -> String {
        switch result {
        case nil: return t(
                "Chưa kiểm tra vị trí. Có thể lưu không nơi.",
                "Location not checked. You can save without a place."
            )
        case .allowed?: return t(
                "Đủ điều kiện, nhưng chưa có ngưỡng đã hiệu chỉnh nên không tự gắn. Có thể chọn nơi thủ công.",
                "Eligible, but no calibrated thresholds yet, so nothing is attached automatically. You can choose a place."
            )
        case .hidden?: return t("Vị trí đang ẩn; không gửi tọa độ.", "Location hidden; no coordinates are sent.")
        case .noConsent?: return t(
                "Chưa cho phép nhận diện bên ngoài; không gửi tọa độ.",
                "External recognition not allowed; no coordinates are sent."
            )
        case .noSample?: return t("Chưa có mẫu vị trí.", "No location sample.")
        case .expired?: return t(
                "Mẫu vị trí quá 60 giây đã bị xóa khỏi bộ nhớ.",
                "The location sample passed 60 seconds and was discarded."
            )
        case .unreliable?: return t(
                "Vị trí gần đúng, sai số >50 m hoặc đã cũ; không tự gắn.",
                "Approximate, over 50 m error or stale; nothing attached automatically."
            )
        case .accountMismatch?: return t(
                "Mẫu thuộc tài khoản khác; đã hủy.",
                "Sample belonged to another account; discarded."
            )
        case .uncertain?: return t(
                "Gần vùng riêng tư hoặc vùng chưa xác nhận; không gửi tọa độ.",
                "Near a private zone or zones unconfirmed; no coordinates are sent."
            )
        case .inside?: return t(
                "Trong vùng riêng tư; không gửi tọa độ.",
                "Inside a private zone; no coordinates are sent."
            )
        }
    }

    func locationText(_ code: String) -> String {
        switch code {
        case "permission": return t("Đang chờ bạn chọn quyền vị trí", "Waiting for your location choice")
        case "requesting": return t("Đang lấy vị trí trên máy", "Getting location on device")
        case "denied": return t(
                "Quyền vị trí bị từ chối. Mở Cài đặt nếu muốn cấp; vẫn chụp và lưu không nơi được.",
                "Location access denied. Open Settings to allow; capture and save without a place still work."
            )
        case "restricted": return t("Vị trí bị hạn chế trên thiết bị này.", "Location is restricted on this device.")
        case "received": return t(
                "Đã nhận một mẫu vị trí (chỉ trong bộ nhớ, tối đa 60 giây).",
                "Received one location sample (memory only, up to 60 seconds)."
            )
        case "approximate": return t(
                "Chỉ có vị trí gần đúng; không tự gắn.",
                "Approximate location only; nothing attached automatically."
            )
        case "stale": return t("Vị trí cũ hơn 60 giây; không dùng.", "Location older than 60 seconds; not used.")
        case "unavailable": return t("Không lấy được vị trí lúc này.", "Location unavailable right now.")
        default: return ""
        }
    }

    /// Why no Place can be attached while zone protection is on; empty when zones do not block.
    func zoneText(_ status: ZoneStatus) -> String {
        switch status {
        case .off, .outside: return ""
        case .inside: return t(
                "Ảnh ở trong vùng riêng tư nên không gắn được địa điểm. Ảnh vẫn được lưu.",
                "This photo is inside a private zone, so no place can be attached. The photo is still saved."
            )
        case .uncertain:
            if !policy.zonesVerified {
                return t(
                    "Danh sách vùng riêng tư chưa được xác nhận trong Cài đặt nên chưa gắn được địa điểm.",
                    "Your private zone list is not confirmed in Settings, so no place can be attached yet."
                )
            }
            if reviewDraft?.origin.hasPrefix("library") == true {
                return t(
                    "GPS của ảnh không cho thấy chắc chắn ảnh ở ngoài vùng riêng tư nên chưa gắn được địa điểm.",
                    "The photo's own GPS does not show it is clearly outside your private zones, so no place can " +
                        "be attached."
                )
            }
            return t(
                "Chưa chắc ảnh ở ngoài vùng riêng tư nên chưa gắn được địa điểm. Kiểm tra vị trí trong 60 giây sau " +
                    "khi chụp.",
                "It is not clear this photo was taken outside your private zones, so no place can be attached. " +
                    "Check location within 60 seconds of taking it."
            )
        }
    }
}
