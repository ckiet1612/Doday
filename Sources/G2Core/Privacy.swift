import Foundation

public struct Coordinate: Codable, Hashable, Sendable {
    public var latitude: Double
    public var longitude: Double
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude; self.longitude = longitude
    }

    public var isValid: Bool {
        latitude.isFinite && longitude.isFinite && abs(latitude) <= 90 && abs(longitude) <= 180
    }

    public func distance(to other: Coordinate) -> Double {
        let lat = (other.latitude - latitude) * .pi / 180
        let lon = (other.longitude - longitude) * .pi / 180
        let latitudes = cos(latitude * .pi / 180) * cos(other.latitude * .pi / 180)
        let haversine = min(1, max(0, pow(sin(lat / 2), 2) + latitudes * pow(sin(lon / 2), 2)))
        return 6_371_000 * 2 * atan2(sqrt(haversine), sqrt(1 - haversine))
    }
}

public struct PrivacyZone: Codable, Identifiable, Equatable, Sendable {
    public var id: UUID
    public var name: String
    public var center: Coordinate
    public var radius: Double
    public init(id: UUID = UUID(), name: String = "", center: Coordinate, radius: Double = 200) {
        self.id = id; self.name = name; self.center = center; self.radius = radius
    }
}

public struct PrivacyPolicy: Codable, Sendable {
    public var accountID: String
    public var revision: Int
    public var hide: Bool
    public var zoneProtection: Bool
    public var zonesVerified: Bool
    public var externalConsent: Bool
    public var zones: [PrivacyZone]
    public init(
        accountID: String,
        revision: Int,
        hide: Bool,
        zoneProtection: Bool,
        zonesVerified: Bool,
        externalConsent: Bool,
        zones: [PrivacyZone]
    ) {
        self.accountID = accountID; self.revision = revision; self.hide = hide
        self.zoneProtection = zoneProtection; self.zonesVerified = zonesVerified
        self.externalConsent = externalConsent; self.zones = zones
    }

    public static func safeDefault(accountID: String) -> Self {
        .init(
            accountID: accountID,
            revision: 0,
            hide: true,
            zoneProtection: true,
            zonesVerified: false,
            externalConsent: false,
            zones: []
        )
    }
}

public struct LocationSample: Sendable {
    public var coordinate: Coordinate
    public var accuracy: Double
    public var ageAtReceipt: TimeInterval
    public var receivedAtUptime: TimeInterval
    public var precise: Bool
    public var accountID: String
    public init(
        coordinate: Coordinate,
        accuracy: Double,
        ageAtReceipt: TimeInterval,
        receivedAtUptime: TimeInterval,
        precise: Bool,
        accountID: String
    ) {
        self.coordinate = coordinate; self.accuracy = accuracy; self.ageAtReceipt = ageAtReceipt
        self.receivedAtUptime = receivedAtUptime; self.precise = precise; self.accountID = accountID
    }
}

public enum GateResult: String, Sendable {
    case allowed, hidden, noConsent, noSample, expired, unreliable, accountMismatch, uncertain, inside
    public var allowsCoordinates: Bool {
        self == .allowed
    }
}

public enum PrivacyGate {
    public static func evaluate(policy: PrivacyPolicy, sample: LocationSample?, nowUptime: TimeInterval) -> GateResult {
        guard !policy.hide else { return .hidden }
        guard policy.externalConsent else { return .noConsent }
        guard let sample else { return .noSample }
        guard sample.accountID == policy.accountID else { return .accountMismatch }
        let elapsed = nowUptime - sample.receivedAtUptime
        guard elapsed.isFinite, elapsed >= 0, elapsed < 60 else { return .expired }
        guard isReliable(sample, elapsed: elapsed) else { return .unreliable }
        switch ZoneStatus.classify(sample.coordinate, accuracy: sample.accuracy, policy: policy) {
        case .inside: return .inside
        case .uncertain: return .uncertain
        case .off, .outside: return .allowed
        }
    }

    /// B1 trial limits: precise, ≤50 m and at most 60 s old, counting time spent in RAM since receipt.
    static func isReliable(_ sample: LocationSample, elapsed: TimeInterval) -> Bool {
        sample.coordinate.isValid && sample.precise && sample.accuracy.isFinite && sample.accuracy >= 0 &&
            sample.accuracy <= 50 && sample.ageAtReceipt.isFinite && sample.ageAtReceipt >= 0 &&
            sample.ageAtReceipt + elapsed <= 60
    }
}

/// Where a photo was taken relative to active private zones (addendum §3.2, A2). Missing, weak or unrelated
/// evidence is `uncertain`, never `outside`.
public enum ZoneStatus: String, Sendable {
    case off, outside, inside, uncertain

    /// Seconds after a camera capture during which a location check still describes where the photo was taken.
    public static let cameraWindow: TimeInterval = 60

    /// Hide and an active zone (inside or uncertain) both win over choosing a Place, manual or automatic.
    /// Choosing a Place never lifts either protection.
    public func allowsPlace(hidden: Bool) -> Bool {
        !hidden && (self == .off || self == .outside)
    }

    public static func classify(_ point: Coordinate?, accuracy: Double?, policy: PrivacyPolicy) -> Self {
        guard policy.zoneProtection else { return .off }
        guard let point, point.isValid, let accuracy, accuracy.isFinite, accuracy >= 0, policy.zonesVerified,
              policy.zones.allSatisfy({ $0.center.isValid && $0.radius.isFinite && (100 ... 1000).contains($0.radius) })
        else { return .uncertain }
        for zone in policy.zones {
            let distance = point.distance(to: zone.center)
            if distance <= zone.radius {
                return .inside
            }
            if distance - accuracy <= zone.radius {
                return .uncertain
            }
        }
        return .outside
    }

    /// A camera photo has no GPS of its own. Only a reliable sample for this account, received within
    /// `cameraWindow` of the capture, says where it was taken; a later check only says where the phone is now.
    public static func cameraPhoto(
        sample: LocationSample,
        secondsSinceCapture: TimeInterval,
        policy: PrivacyPolicy,
        nowUptime: TimeInterval
    ) -> Self {
        guard policy.zoneProtection else { return .off }
        let elapsed = nowUptime - sample.receivedAtUptime
        guard sample.accountID == policy.accountID, secondsSinceCapture.isFinite, secondsSinceCapture >= 0,
              secondsSinceCapture <= cameraWindow, elapsed.isFinite, elapsed >= 0,
              PrivacyGate.isReliable(sample, elapsed: elapsed) else { return .uncertain }
        return classify(sample.coordinate, accuracy: sample.accuracy, policy: policy)
    }
}

public struct RecognitionTicket: Sendable {
    public let accountID: String
    public let revision: Int
    public let issuedAtUptime: TimeInterval
    public init(accountID: String, revision: Int, issuedAtUptime: TimeInterval) {
        self.accountID = accountID; self.revision = revision; self.issuedAtUptime = issuedAtUptime
    }

    public func isCurrent(policy: PrivacyPolicy, sample: LocationSample?, nowUptime: TimeInterval) -> Bool {
        accountID == policy.accountID && revision == policy.revision && nowUptime >= issuedAtUptime &&
            nowUptime - issuedAtUptime < 60 && PrivacyGate
            .evaluate(policy: policy, sample: sample, nowUptime: nowUptime).allowsCoordinates
    }
}

public struct Calibration: Sendable {
    public let auto: Double
    public let confirm: Double
    public let contextTTL: TimeInterval
    public let version: String
    public init(auto: Double, confirm: Double, contextTTL: TimeInterval, version: String) {
        self.auto = auto; self.confirm = confirm; self.contextTTL = contextTTL; self.version = version
    }
}

public enum Assignment: String { case unassigned, confirm, automatic }
public enum AssignmentPolicy {
    public static func decide(score: Double, runnerUp: Double, calibration: Calibration?) -> Assignment {
        guard let calibration, calibration.auto > calibration.confirm, calibration.auto <= 1,
              calibration.confirm >= 0, calibration.contextTTL > 0,
              score.isFinite, runnerUp.isFinite, (0 ... 1).contains(score), (0 ... 1).contains(runnerUp),
              score >= calibration.confirm
        else { return .unassigned }
        return score >= calibration.auto && runnerUp < calibration.confirm ? .automatic : .confirm
    }
}

// B3: compares a library photo's own GPS with the place being attached. Runs on device only and never
// uses GPS that Hide or an active zone would block (backlog MVP-06 E1). Current device GPS is never an input.
public enum LibraryPlaceCheck: Equatable, Sendable {
    case noPhotoGPS, blocked, placeWithoutCoordinate, consistent, mismatch(meters: Double)
    public static let thresholdMeters = 1000.0
    /// EXIF often omits horizontal error; assume the B1 accuracy ceiling rather than a perfect fix.
    public static let assumedAccuracy = 50.0

    public static func evaluate(
        photo: Coordinate?,
        photoAccuracy: Double?,
        place: Coordinate?,
        hidden: Bool,
        policy: PrivacyPolicy
    ) -> Self {
        guard let photo, photo.isValid else { return .noPhotoGPS }
        let zone = ZoneStatus.classify(photo, accuracy: photoAccuracy ?? assumedAccuracy, policy: policy)
        guard zone.allowsPlace(hidden: hidden) else { return .blocked }
        guard let place, place.isValid else { return .placeWithoutCoordinate }
        let distance = photo.distance(to: place)
        return distance > thresholdMeters ? .mismatch(meters: distance) : .consistent
    }
}
