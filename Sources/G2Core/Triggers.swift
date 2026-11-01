import Foundation

public enum APITrigger: String, CaseIterable, Sendable {
    case appOpen, cameraOpen, capture, save, mapOpen, pan, zoom, search, nearby, details, viewPhotos, viewReviews
}

public struct RequestDescriptor: Sendable { public let fields: [String] }
public enum TriggerPolicy {
    public static let minimumQueryLength = 2
    public static let debounceMilliseconds = 400
    public static let maximumRetries = 2
    public static func request(for event: APITrigger) -> RequestDescriptor? {
        switch event {
        case .search, .nearby:
            return RequestDescriptor(fields: [
                "places.id",
                "places.displayName",
                "places.location",
                "places.businessStatus",
                "places.attributions",
            ])
        case .details:
            return RequestDescriptor(fields: [
                "id",
                "displayName",
                "formattedAddress",
                "location",
                "businessStatus",
                "attributions",
                "movedPlace",
                "movedPlaceId",
            ])
        case .viewPhotos: return RequestDescriptor(fields: ["id", "photos", "attributions"])
        case .viewReviews: return RequestDescriptor(fields: ["id", "reviews", "attributions"])
        default: return nil
        }
    }
}

public enum MapLinks {
    public static func directions(placeID: String, label: String) -> URL? {
        guard !placeID.isEmpty, placeID.count <= 512 else { return nil }
        var parts = URLComponents(string: "https://www.google.com/maps/dir/")
        parts?.queryItems = [
            URLQueryItem(name: "api", value: "1"),
            URLQueryItem(name: "destination", value: label.isEmpty ? placeID : label),
            URLQueryItem(name: "destination_place_id", value: placeID),
        ]
        return parts?.url
    }
}
