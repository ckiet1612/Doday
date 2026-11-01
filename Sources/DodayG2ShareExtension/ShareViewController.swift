import G2Core
import UIKit
import UniformTypeIdentifiers

final class ShareViewController: UIViewController {
    private let status = UILabel()
    private let save = UIButton(type: .system)
    private var inbox: ShareInbox?
    private var owner: InboxOwner?
    private var payload: String?
    private var types: [String] = []
    private var english: Bool {
        Locale.preferredLanguages.first?.hasPrefix("en") == true
    }

    private func t(_ vi: String, _ en: String) -> String {
        english ? en : vi
    }

    override func viewDidLoad() {
        super.viewDidLoad(); view.backgroundColor = .systemBackground
        let title = UILabel(); title.text = "Doday G2"; title.font = .preferredFont(forTextStyle: .title2)
        status.font = .preferredFont(forTextStyle: .body); status.numberOfLines = 0
        status.adjustsFontForContentSizeCategory = true; title.adjustsFontForContentSizeCategory = true
        let cancel = UIButton(type: .system); cancel.setTitle(t("Đóng", "Close"), for: .normal)
        cancel.addTarget(self, action: #selector(close), for: .touchUpInside)
        save.setTitle(t("Lưu liên kết · PENDING", "Save link · PENDING"), for: .normal)
        save.isEnabled = false; save.addTarget(self, action: #selector(saveLink), for: .touchUpInside)
        let stack = UIStackView(arrangedSubviews: [title, status, save, cancel]); stack.axis = .vertical; stack
            .spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false; view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            save.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            cancel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
        ])
        Task { await prepare() }
    }

    @MainActor private func prepare() async {
        // Read first: the offered type identifiers are G2 evidence even when nothing may be saved.
        let providers = (extensionContext?.inputItems as? [NSExtensionItem] ?? []).flatMap { $0.attachments ?? [] }
        var received: ReceivedShare?
        for provider in providers {
            if let value = try? await ItemProviderReader.read(provider) { received = value; break }
        }
        let offered = received.map { [$0.type] + $0.registeredTypes.filter { $0 != received?.type } }
            ?? providers.flatMap(\.registeredTypeIdentifiers)
        let typeList = "\n\n" + (offered.isEmpty ? "–" : offered.joined(separator: ", "))
        guard let received else {
            status.text = t(
                "Không nhận được URL hoặc text HTTPS hỗ trợ. Chưa lưu dữ liệu.",
                "No supported HTTPS URL/text received. No data saved."
            ) + typeList; return
        }
        guard let root = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.ckiet1612.doday.g2")
        else {
            // Builds signed without the App Group (free-team fallback) can only report what was offered.
            status.text = t(
                "Bản build này không có App Group nên chưa lưu được liên kết. Chỉ ghi nhận kiểu dữ liệu nhận được.",
                "This build has no App Group, so the link cannot be saved. Only the received types are shown."
            ) + typeList; return
        }
        do {
            let inbox = try ShareInbox(root: root.appendingPathComponent("share-inbox")); self.inbox = inbox
            guard let owner = try inbox.owner() else {
                status.text = t(
                    "Chưa có tài khoản. Hãy mở Doday và đăng nhập trước khi chia sẻ lại; chưa lưu liên kết.",
                    "No account. Open Doday and sign in before sharing again; link has not been saved."
                ) + typeList; return
            }
            self.owner = owner
            payload = received.text; types = offered
            status.text = t(
                "Liên kết được lưu riêng cho tài khoản hiện tại. Chưa xác định địa điểm; không tải metadata bên ngoài.",
                "Link will be private to the current account. Place is not identified; no external metadata is fetched."
            ) + typeList
            save.isEnabled = true
        } catch { status.text = t(
            "Không đọc được kho chia sẻ trên máy. Chưa lưu.",
            "Could not read local share storage. Not saved."
        ) }
    }

    @objc private func saveLink() {
        guard let inbox, let owner, let payload else { return }
        save.isEnabled = false
        do {
            let result = try inbox.append(text: payload, owner: owner, types: types)
            status.text = result.duplicate ? t("Đã có trong Doday", "Already in Doday") : t(
                "Đã lưu trên máy · PENDING",
                "Saved on device · PENDING"
            )
            self.payload = nil
            // The write is already durable; the short pause only lets the confirmation be read.
            DispatchQueue.main
                .asyncAfter(deadline: .now() + 0.9) { [weak self] in
                    self?.extensionContext?.completeRequest(returningItems: nil)
                }
        } catch { status.text = t(
            "Tài khoản đã thay đổi hoặc lưu lỗi. Chưa xác nhận lưu; chia sẻ lại từ nguồn.",
            "Account changed or write failed. Save not confirmed; share again from the source."
        ) }
    }

    @objc private func close() {
        payload = nil; extensionContext?.completeRequest(returningItems: nil)
    }
}
