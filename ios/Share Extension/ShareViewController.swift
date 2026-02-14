import UIKit
import MobileCoreServices

class ShareViewController: UIViewController {
    private let logSession = String(UUID().uuidString.prefix(8))
    private let cardView = UIView()
    private let contentStack = UIStackView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private func log(_ message: String) {
        print("[ShareExtension][\(logSession)] \(message)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.96)
        setupUI()
        log("viewDidLoad")
        processSharedItems()
    }

    private func setupUI() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 14
        contentStack.alignment = .fill
        contentStack.distribution = .fill

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.text = "正在处理分享"

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.text = "请稍候，正在保存文件…"

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()

        let indicatorContainer = UIView()
        indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        indicatorContainer.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: indicatorContainer.topAnchor, constant: 2),
            activityIndicator.bottomAnchor.constraint(equalTo: indicatorContainer.bottomAnchor, constant: -2),
            activityIndicator.centerXAnchor.constraint(equalTo: indicatorContainer.centerXAnchor)
        ])

        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle("确定", for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        actionButton.backgroundColor = .systemBlue
        actionButton.tintColor = .white
        actionButton.layer.cornerRadius = 12
        actionButton.isHidden = true
        actionButton.addTarget(self, action: #selector(onTapConfirm), for: .touchUpInside)
        actionButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

        view.addSubview(cardView)
        cardView.addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(messageLabel)
        contentStack.addArrangedSubview(indicatorContainer)
        contentStack.addArrangedSubview(actionButton)

        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
        ])
    }

    private func processSharedItems() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = extensionItem.attachments,
              !attachments.isEmpty else {
            let itemCount = extensionContext?.inputItems.count ?? 0
            log("No attachments. inputItems=\(itemCount)")
            closeExtension()
            return
        }

        log("Processing attachments count=\(attachments.count)")
        handleAttachments(attachments)
    }

    private func handleAttachments(_ attachments: [NSItemProvider]) {
        let typeIdentifiers = [
            "public.file-url",
            "public.url",
            "public.text",
            "public.xml",
            kUTTypeData as String,
            "public.data",
            "public.content",
            "public.item"
        ]

        for attachment in attachments {
            log("Checking attachment suggestedName=\(attachment.suggestedName ?? "nil")")
            for typeId in typeIdentifiers {
                if attachment.hasItemConformingToTypeIdentifier(typeId) {
                    log("Matched typeIdentifier=\(typeId)")
                    loadItem(attachment, typeIdentifier: typeId)
                    return
                }
            }
        }

        log("No matching typeIdentifier in incoming attachments")
        closeExtension()
    }

    private func loadItem(_ attachment: NSItemProvider, typeIdentifier: String) {
        log("loadItem start typeIdentifier=\(typeIdentifier), suggestedName=\(attachment.suggestedName ?? "nil")")
        attachment.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { [weak self] item, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.log("loadItem error: \(error)")
                    self?.closeExtension()
                    return
                }

                guard let self = self else { return }

                if let url = item as? URL {
                    self.log("loadItem got URL=\(url)")
                    self.saveAndNotify(sourceURL: url, suggestedName: attachment.suggestedName)
                } else if let data = item as? Data {
                    self.log("loadItem got Data bytes=\(data.count)")
                    self.saveDataAndNotify(data, suggestedName: attachment.suggestedName)
                } else if let text = item as? String {
                    self.log("loadItem got String length=\(text.count)")
                    guard let textData = text.data(using: .utf8) else {
                        self.log("Failed to encode String as UTF-8")
                        self.closeExtension()
                        return
                    }
                    self.saveDataAndNotify(textData, suggestedName: attachment.suggestedName)
                } else {
                    self.log("Unknown item type=\(String(describing: type(of: item)))")
                    self.closeExtension()
                }
            }
        }
    }

    private func saveAndNotify(sourceURL: URL, suggestedName: String?) {
        guard sourceURL.isFileURL else {
            log("Source URL is not file URL: \(sourceURL)")
            closeExtension()
            return
        }

        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.zhuyl.echoPod"
        ) else {
            log("Failed to resolve App Group container URL")
            closeExtension()
            return
        }

        let scoped = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if scoped {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }

        let sourceName = sourceURL.lastPathComponent
        let fallbackName = "shared_\(Int(Date().timeIntervalSince1970))"
        let rawName = normalizedFileName(
            preferredName: suggestedName,
            fallbackName: sourceName.isEmpty ? fallbackName : sourceName
        )
        let fileName = ensureOpmlExtension(rawName)
        let destinationURL = containerURL.appendingPathComponent(fileName)

        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
                log("Removed existing file at destination=\(destinationURL.lastPathComponent)")
            }

            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            log("Copied file source=\(sourceURL.lastPathComponent) -> dest=\(destinationURL.lastPathComponent)")

            saveMetadata(filePath: destinationURL.path, fileName: fileName)
            showCompletionState(fileName: fileName)
        } catch {
            log("saveAndNotify error: \(error)")
            showFailureState(message: "文件保存失败，请稍后重试。")
        }
    }

    private func saveDataAndNotify(_ data: Data, suggestedName: String?) {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.zhuyl.echoPod"
        ) else {
            log("Failed to resolve App Group container URL")
            closeExtension()
            return
        }

        let timestamp = Int(Date().timeIntervalSince1970)
        let suggested = suggestedName?.trimmingCharacters(in: .whitespacesAndNewlines)
        let baseName = normalizedFileName(
            preferredName: suggested,
            fallbackName: "shared_\(timestamp)"
        )
        let fileName = ensureOpmlExtension(baseName)
        let destinationURL = containerURL.appendingPathComponent(fileName)

        do {
            try data.write(to: destinationURL)
            log("Wrote data bytes=\(data.count) to \(destinationURL.lastPathComponent)")

            saveMetadata(filePath: destinationURL.path, fileName: fileName)
            showCompletionState(fileName: fileName)
        } catch {
            log("saveDataAndNotify error: \(error)")
            showFailureState(message: "文件保存失败，请稍后重试。")
        }
    }

    private func saveMetadata(filePath: String, fileName: String) {
        let sharedDefaults = UserDefaults(suiteName: "group.com.zhuyl.echoPod")
        sharedDefaults?.set(filePath, forKey: "shared_file_path")
        sharedDefaults?.set(fileName, forKey: "shared_file_name")
        sharedDefaults?.set(Date().timeIntervalSince1970, forKey: "shared_file_timestamp")
        sharedDefaults?.synchronize()
        log("Metadata saved fileName=\(fileName), filePath=\(filePath)")
    }

    private func showCompletionState(fileName: String) {
        log("Show completion state fileName=\(fileName)")
        titleLabel.text = "已分享到亦可"
        messageLabel.text = "文件“\(fileName)”已分享完成。\n请手动打开亦可 App 继续导入。"
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        actionButton.isHidden = false
    }

    private func showFailureState(message: String) {
        log("Show failure state message=\(message)")
        titleLabel.text = "分享失败"
        messageLabel.text = message
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        actionButton.isHidden = false
    }

    @objc private func onTapConfirm() {
        log("User tapped 确定")
        closeExtension()
    }

    private func closeExtension() {
        log("Closing extension")
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    private func normalizedFileName(preferredName: String?, fallbackName: String) -> String {
        let candidate: String
        if let preferredName, !preferredName.isEmpty {
            candidate = preferredName
        } else {
            candidate = fallbackName
        }
        let sanitized = candidate.replacingOccurrences(of: "/", with: "_")
        return sanitized.isEmpty ? fallbackName : sanitized
    }

    private func ensureOpmlExtension(_ fileName: String) -> String {
        return fileName.lowercased().hasSuffix(".opml") ? fileName : "\(fileName).opml"
    }
}
