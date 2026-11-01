import Foundation

@MainActor
public final class RecognitionVault {
    private var sample: LocationSample?
    private var expiry: Task<Void, Never>?
    public init() {}
    public func accept(_ value: LocationSample, now: TimeInterval = ProcessInfo.processInfo.systemUptime) {
        discard()
        let remaining = 60 - (now - value.receivedAtUptime)
        guard remaining > 0, remaining <= 60 else { return }
        sample = value
        expiry = Task { [weak self] in
            do { try await Task.sleep(nanoseconds: UInt64(remaining * 1_000_000_000)) }
            catch { return }
            self?.sample = nil
        }
    }

    public func current(now: TimeInterval = ProcessInfo.processInfo.systemUptime) -> LocationSample? {
        guard let sample else { return nil }
        guard now >= sample.receivedAtUptime, now - sample.receivedAtUptime < 60 else { discard(); return nil }
        return sample
    }

    public func discard() {
        sample = nil; expiry?.cancel(); expiry = nil
    }

    deinit { expiry?.cancel() }
}

public struct SavedIntent: Codable, Identifiable, Sendable {
    public var id: String {
        placeID
    }

    public let placeID: String
    public var userLabel: String
    public var collection: String
    public var visited: Bool
    public let savedAt: Date
}

public final class SavedStore {
    private let url: URL
    public init(root: URL, accountID: String) throws {
        guard !accountID.isEmpty else { throw G2Error.noAccount }
        let folder = root.appendingPathComponent(LocalFiles.accountKey(accountID)); try LocalFiles.directory(folder)
        url = folder.appendingPathComponent("saved-intents.json")
    }

    public func list() throws -> [SavedIntent] {
        guard FileManager.default.fileExists(atPath: url.path) else { return [] }
        return try JSONDecoder().decode([SavedIntent].self, from: Data(contentsOf: url))
    }

    private func write(_ items: [SavedIntent]) throws {
        try LocalFiles.write(JSONEncoder().encode(items), to: url)
    }

    public func save(placeID: String, userLabel: String = "", collection: String = "") throws {
        guard !placeID.isEmpty else { throw G2Error.invalidURL }
        var items = try list()
        if let index = items.firstIndex(where: { $0.placeID == placeID }) {
            items[index].userLabel = String(userLabel.prefix(120)); items[index]
                .collection = String(collection.prefix(80))
        } else {
            items.append(SavedIntent(
                placeID: placeID,
                userLabel: String(userLabel.prefix(120)),
                collection: String(collection.prefix(80)),
                visited: false,
                savedAt: Date()
            ))
        }
        try write(items)
    }

    public func setVisited(_ placeID: String, visited: Bool) throws {
        var items = try list()
        guard let index = items.firstIndex(where: { $0.placeID == placeID }) else { throw G2Error.storage }
        items[index].visited = visited; try write(items)
    }

    public func remove(_ placeID: String) throws {
        try write(list().filter { $0.placeID != placeID })
    }
}
