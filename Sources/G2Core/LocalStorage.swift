import CryptoKit
import Foundation
import SwiftData

public enum LocalFiles {
    public static func accountKey(_ accountID: String) -> String {
        SHA256.hash(data: Data(accountID.utf8)).map { String(format: "%02x", $0) }.joined()
    }

    public static func directory(_ url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        var target = url
        var values = URLResourceValues(); values.isExcludedFromBackup = true
        try target.setResourceValues(values)
    }

    public static func write(_ data: Data, to url: URL) throws {
        try data.write(to: url, options: [.atomic, .completeFileProtectionUnlessOpen])
        var target = url
        var values = URLResourceValues(); values.isExcludedFromBackup = true
        try target.setResourceValues(values)
    }
}

@Model
final class DraftRecord {
    @Attribute(.unique) var id: UUID
    var origin: String
    var createdAt: Date
    var capturedAt: Date?
    var state: String
    var title: String
    var hidden: Bool
    // Place link is kept apart from the image so stripping GPS never removes it (A1).
    var placeID: String?
    init(id: UUID, origin: String, capturedAt: Date?) {
        self.id = id; self.origin = origin; createdAt = Date(); self.capturedAt = capturedAt
        state = "sourceSaved"; title = ""; hidden = true
    }
}

public struct DraftSummary: Identifiable {
    public let id: UUID
    public let title: String
    public let state: String
    public let createdAt: Date
    public let capturedAt: Date?
    public let hidden: Bool
    public let origin: String
    public let placeID: String?
}

@MainActor
public final class DraftStore {
    private let folder: URL
    private let container: ModelContainer
    private let context: ModelContext
    public init(root: URL, accountID: String) throws {
        guard !accountID.isEmpty else { throw G2Error.noAccount }
        folder = root.appendingPathComponent(LocalFiles.accountKey(accountID))
        try LocalFiles.directory(folder)
        let configuration = ModelConfiguration(
            url: folder.appendingPathComponent("drafts.store"),
            allowsSave: true,
            cloudKitDatabase: .none
        )
        container = try ModelContainer(for: DraftRecord.self, configurations: configuration)
        context = ModelContext(container); context.autosaveEnabled = false
        // Reconcile a source-first interrupted write. No derivative or GPS needs to be recovered.
        let records = try context.fetch(FetchDescriptor<DraftRecord>())
        let known = Set(records.map(\.id))
        for file in try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)
            where file.pathExtension == "source"
        {
            if let id = UUID(uuidString: file.deletingPathExtension().lastPathComponent), !known.contains(id) {
                context.insert(DraftRecord(id: id, origin: "recovered", capturedAt: nil))
            }
        }
        try context.save()
    }

    public func sourceURL(_ id: UUID) -> URL {
        folder.appendingPathComponent(id.uuidString + ".source")
    }

    public func imageURL(_ id: UUID, thumbnail: Bool = false) -> URL {
        folder.appendingPathComponent(id.uuidString + (thumbnail ? ".thumb.jpg" : ".main.jpg"))
    }

    public func capture(source: Data, origin: String, capturedAt: Date?) throws -> UUID {
        let id = UUID()
        try LocalFiles.write(source, to: sourceURL(id))
        context.insert(DraftRecord(id: id, origin: origin, capturedAt: capturedAt))
        try context.save()
        return id
    }

    private func record(_ id: UUID) throws -> DraftRecord {
        let descriptor = FetchDescriptor<DraftRecord>(predicate: #Predicate { $0.id == id })
        guard let value = try context.fetch(descriptor).first else { throw G2Error.storage }
        return value
    }

    public func process(_ id: UUID) throws {
        _ = try record(id)
        do {
            let output = try ImagePipeline.process(source: Data(contentsOf: sourceURL(id)))
            try complete(id, output: output)
        } catch {
            try markProcessingFailed(id); throw error
        }
    }

    public func complete(_ id: UUID, output: ProcessedImage) throws {
        let draft = try record(id)
        try LocalFiles.write(output.main, to: imageURL(id))
        try LocalFiles.write(output.thumbnail, to: imageURL(id, thumbnail: true))
        draft.state = "localReady"; try context.save()
    }

    public func markProcessingFailed(_ id: UUID) throws {
        let draft = try record(id); draft.state = "processingFailed"; try context.save()
    }

    public func update(_ id: UUID, title: String, hidden: Bool) throws {
        let draft = try record(id); draft.title = String(title.prefix(120)); draft.hidden = hidden
        try context.save()
    }

    public func attach(_ id: UUID, placeID: String?) throws {
        let draft = try record(id); draft.placeID = placeID; try context.save()
    }

    public func remove(_ id: UUID) throws {
        let draft = try record(id); context.delete(draft); try context.save()
        for file in [sourceURL(id), imageURL(id), imageURL(id, thumbnail: true)] {
            if FileManager.default.fileExists(atPath: file.path) {
                try FileManager.default.removeItem(at: file)
            }
        }
    }

    public func list() throws -> [DraftSummary] {
        try context.fetch(FetchDescriptor<DraftRecord>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])).map {
            DraftSummary(
                id: $0.id,
                title: $0.title,
                state: $0.state,
                createdAt: $0.createdAt,
                capturedAt: $0.capturedAt,
                hidden: $0.hidden,
                origin: $0.origin,
                placeID: $0.placeID
            )
        }
    }
}

public final class PolicyStore {
    private let url: URL
    public let accountID: String
    public init(root: URL, accountID: String) throws {
        self.accountID = accountID
        let folder = root.appendingPathComponent(LocalFiles.accountKey(accountID))
        try LocalFiles.directory(folder); url = folder.appendingPathComponent("privacy.json")
    }

    public func load() throws -> PrivacyPolicy {
        guard FileManager.default.fileExists(atPath: url.path) else { return .safeDefault(accountID: accountID) }
        let policy = try JSONDecoder().decode(PrivacyPolicy.self, from: Data(contentsOf: url))
        guard policy.accountID == accountID else { throw G2Error.storage }
        return policy
    }

    public func save(_ policy: PrivacyPolicy) throws {
        guard policy.accountID == accountID else { throw G2Error.noAccount }
        try LocalFiles.write(JSONEncoder().encode(policy), to: url)
    }
}
