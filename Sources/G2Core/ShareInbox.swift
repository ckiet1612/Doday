import Foundation
import UniformTypeIdentifiers

public struct InboxOwner: Codable, Equatable, Sendable {
    public let accountID: String
    public let epoch: UUID
    public init(accountID: String, epoch: UUID) {
        self.accountID = accountID; self.epoch = epoch
    }
}

public struct SharePayload: Sendable {
    public let url: URL
    public let canonicalURL: String
    public static func parse(_ text: String) throws -> Self {
        guard text.utf8.count <= 16384 else { throw G2Error.invalidURL }
        let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: text, range: NSRange(text.startIndex..., in: text))
        guard let url = matches.compactMap(\.url).first,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.scheme?.lowercased() == "https",
              let host = components.host, !host.isEmpty, components.user == nil, components.password == nil,
              host != "localhost", !host.hasSuffix(".local"), components.port == nil else { throw G2Error.invalidURL }
        components.scheme = "https"; components.host = host.lowercased(); components.fragment = nil
        components.queryItems = components.queryItems?.filter { !$0.name.lowercased().hasPrefix("utm_") }
        if components.queryItems?.isEmpty == true {
            components.queryItems = nil
        }
        guard let canonical = components.url else { throw G2Error.invalidURL }
        return SharePayload(url: url, canonicalURL: canonical.absoluteString)
    }
}

public struct InboxItem: Codable, Identifiable, Sendable {
    public let id: UUID
    public let accountID: String
    public let canonicalURL: String
    public let receivedAt: Date
    public var state: String
    public var receivedTypes: [String]?
}

public struct InboxAppend: Sendable {
    public let item: InboxItem
    public let duplicate: Bool
}

private struct InboxDocument: Codable { var owner: InboxOwner?; var items: [InboxItem] = [] }

public final class ShareInbox {
    private let url: URL
    public init(root: URL) throws {
        try LocalFiles.directory(root); url = root.appendingPathComponent("inbox.json")
    }

    /// All owner checks, dedupe and writes occur within one cross-process file coordination transaction.
    private func transaction<T>(_ body: (inout InboxDocument) throws -> T) throws -> T {
        let coordinator = NSFileCoordinator(filePresenter: nil)
        var coordinationError: NSError?
        var result: Result<T, Error>?
        coordinator.coordinate(writingItemAt: url, options: .forMerging, error: &coordinationError) { coordinatedURL in
            result = Result {
                var document = InboxDocument()
                if FileManager.default.fileExists(atPath: coordinatedURL.path) {
                    document = try JSONDecoder().decode(InboxDocument.self, from: Data(contentsOf: coordinatedURL))
                }
                let value = try body(&document)
                try LocalFiles.write(JSONEncoder().encode(document), to: coordinatedURL)
                return value
            }
        }
        if let error = coordinationError {
            throw error
        }
        guard let result else { throw G2Error.storage }
        return try result.get()
    }

    public func setOwner(_ owner: InboxOwner?) throws {
        try transaction { $0.owner = owner }
    }

    public func owner() throws -> InboxOwner? {
        try transaction { $0.owner }
    }

    public func append(text: String, owner: InboxOwner?, types: [String]? = nil) throws -> InboxAppend {
        guard let owner, !owner.accountID.isEmpty else { throw G2Error.noAccount }
        let payload = try SharePayload.parse(text)
        return try transaction { document in
            guard document.owner == owner else { throw G2Error.staleOwner }
            if let prior = document.items
                .first(where: { $0.accountID == owner.accountID && $0.canonicalURL == payload.canonicalURL })
            {
                return InboxAppend(item: prior, duplicate: true)
            }
            let item = InboxItem(
                id: UUID(),
                accountID: owner.accountID,
                canonicalURL: payload.canonicalURL,
                receivedAt: Date(),
                state: "PENDING",
                receivedTypes: types
            )
            document.items.append(item); return InboxAppend(item: item, duplicate: false)
        }
    }

    public func items(for accountID: String) throws -> [InboxItem] {
        try transaction { document in
            guard document.owner?.accountID == accountID else { throw G2Error.noAccount }
            return document.items.filter { $0.accountID == accountID }.sorted { $0.receivedAt > $1.receivedAt }
        }
    }

    public func remove(_ id: UUID, owner: InboxOwner) throws {
        try transaction { document in
            guard document.owner == owner else { throw G2Error.staleOwner }
            document.items.removeAll { $0.id == id && $0.accountID == owner.accountID }
        }
    }
}

public struct ReceivedShare: Sendable {
    public let text: String
    public let type: String
    /// Type identifiers only, recorded as G2 evidence of what a source app really offers; never the URL itself.
    public let registeredTypes: [String]
}

public enum ItemProviderReader {
    public static func read(_ provider: NSItemProvider) async throws -> ReceivedShare {
        let registered = provider.registeredTypeIdentifiers
        // NSURL arrives as a binary plist on iOS (raw UTF-8 on macOS); the class loader decodes either form.
        if provider.canLoadObject(ofClass: NSURL.self), let url = await loadURL(provider),
           (try? SharePayload.parse(url)) != nil
        {
            return ReceivedShare(text: url, type: UTType.url.identifier, registeredTypes: registered)
        }
        for type in [UTType.url.identifier, UTType.plainText.identifier]
            where provider.hasItemConformingToTypeIdentifier(type)
        {
            // Apps hand over NSURL, NSString or raw Data for the same identifier; accept each without fetching
            // anything.
            guard let item = try? await provider.loadItem(forTypeIdentifier: type) else { continue }
            for text in candidates(item) where (try? SharePayload.parse(text)) != nil {
                return ReceivedShare(text: text, type: type, registeredTypes: registered)
            }
        }
        throw G2Error.invalidURL
    }

    private static func candidates(_ item: NSSecureCoding) -> [String] {
        switch item {
        case let url as URL: return [url.absoluteString]
        case let string as String: return [string]
        // UTF-8 first: URL(dataRepresentation:) would percent-escape shared prose and hide the link inside it.
        case let data as Data:
            let plist = (try? PropertyListSerialization.propertyList(from: data, format: nil)) as? [Any]
            return (plist?.compactMap { $0 as? String } ?? [])
                + [String(data: data, encoding: .utf8), URL(dataRepresentation: data, relativeTo: nil)?.absoluteString]
                .compactMap { $0 }
        default: return []
        }
    }

    private static func loadURL(_ provider: NSItemProvider) async -> String? {
        await withCheckedContinuation { continuation in
            _ = provider.loadObject(ofClass: URL.self) { url, _ in continuation.resume(returning: url?.absoluteString) }
        }
    }
}
