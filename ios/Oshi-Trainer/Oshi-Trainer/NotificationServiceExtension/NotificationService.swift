//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by 正留慎也 on 2025/10/05.
//

import UserNotifications
import Intents
import UIKit
import os.log

class NotificationService: UNNotificationServiceExtension {
    // MARK: - Properties

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    private let appGroupId = "group.com.yourcompany.VirtualTrainer"
    private let logger = OSLog(subsystem: "com.yourcompany.VirtualTrainer", category: "NotificationService")

    // MARK: - UNNotificationServiceExtension

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent else {
            contentHandler(request.content)
            return
        }

        // userInfoからトレーナーIDを取得
        guard let trainerIdString = request.content.userInfo["trainerId"] as? String,
              let trainerId = UUID(uuidString: trainerIdString) else {
            os_log("⚠️ トレーナーIDが見つかりません", log: logger, type: .error)
            contentHandler(bestAttemptContent)
            return
        }

        // App Group共有UserDefaultsからトレーナー情報を取得
        guard let sharedDefaults = UserDefaults(suiteName: appGroupId),
              let templatesData = sharedDefaults.data(forKey: "trainerTemplates") else {
            os_log("⚠️ App Groupからトレーナーデータを取得できません", log: logger, type: .error)
            // デフォルトトレーナーで代替
            contentHandler(bestAttemptContent)
            return
        }

        // トレーナーテンプレートをデコード
        let decoder = JSONDecoder()
        guard let templates = try? decoder.decode([OshiTrainerTemplate].self, from: templatesData),
              let template = templates.first(where: { $0.id == trainerId }) else {
            os_log("⚠️ トレーナーテンプレートのデコードに失敗", log: logger, type: .error)
            contentHandler(bestAttemptContent)
            return
        }

        // iOS 15以上でCommunication Notifications対応
        if #available(iOS 15.0, *) {
            updateWithCommunicationIntent(
                content: bestAttemptContent,
                template: template,
                completion: contentHandler
            )
        } else {
            // iOS 14以下は従来形式
            contentHandler(bestAttemptContent)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            os_log("⚠️ Extension実行時間がタイムアウト", log: logger, type: .info)
            contentHandler(bestAttemptContent)
        }
    }

    // MARK: - Communication Intent

    @available(iOS 15.0, *)
    private func updateWithCommunicationIntent(
        content: UNMutableNotificationContent,
        template: OshiTrainerTemplate,
        completion: @escaping (UNNotificationContent) -> Void
    ) {
        // INPersonを作成
        let person = createPerson(from: template)

        // INSendMessageIntentを作成
        let intent = INSendMessageIntent(
            recipients: nil,
            outgoingMessageType: .outgoingMessageText,
            content: content.body,
            speakableGroupName: nil,
            conversationIdentifier: template.id.uuidString,
            serviceName: nil,
            sender: person,
            attachments: nil
        )

        // 画像を明示的に設定
        if let personImage = person.image {
            intent.setImage(personImage, forParameterNamed: \INSendMessageIntent.sender)
        }

        // INInteractionをdonate
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.direction = .incoming
        interaction.donate { error in
            if let error = error {
                os_log("❌ INInteraction donateエラー: %@", log: self.logger, type: .error, error.localizedDescription)
            } else {
                os_log("✅ INInteraction donateに成功", log: self.logger, type: .info)
            }
        }

        do {
            // UNNotificationContentをINSendMessageIntentで更新
            let updatedContent = try content.updating(from: intent)
            os_log("✅ Communication Notificationに変換成功: %@", log: logger, type: .info, template.name)
            completion(updatedContent)
        } catch {
            os_log("❌ Communication Notification変換エラー: %@", log: logger, type: .error, error.localizedDescription)
            completion(content)
        }
    }

    // MARK: - Helper Methods

    private func createPerson(from template: OshiTrainerTemplate) -> INPerson {
        let displayName = template.name
        let personHandle = INPersonHandle(value: template.id.uuidString, type: .unknown)

        // 画像を読み込み
        let image = loadImage(fileName: template.characterImage)

        let person = INPerson(
            personHandle: personHandle,
            nameComponents: nil,
            displayName: displayName,
            image: image,
            contactIdentifier: nil,
            customIdentifier: template.id.uuidString
        )

        return person
    }

    private func loadImage(fileName: String) -> INImage? {
        guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId) else {
            os_log("⚠️ App Groupコンテナが利用できません", log: logger, type: .default)
            return nil
        }

        // ファイル名に.pngを追加（拡張子がない場合）
        let imageFileName = fileName.hasSuffix(".png") ? fileName : "\(fileName).png"

        let imagePath = appGroupURL
            .appendingPathComponent("TrainerImages")
            .appendingPathComponent(imageFileName)

        os_log("📁 画像パスを確認: %@", log: logger, type: .info, imagePath.path)

        // TrainerImagesディレクトリの内容をリスト
        let trainerImagesDir = appGroupURL.appendingPathComponent("TrainerImages")
        if let files = try? FileManager.default.contentsOfDirectory(atPath: trainerImagesDir.path) {
            os_log("📂 TrainerImagesディレクトリの内容: %@", log: logger, type: .info, files.joined(separator: ", "))
        }

        guard FileManager.default.fileExists(atPath: imagePath.path) else {
            os_log("⚠️ 画像ファイルが見つかりません: %@", log: logger, type: .default, imageFileName)
            return nil
        }

        guard let uiImage = UIImage(contentsOfFile: imagePath.path),
              let imageData = uiImage.pngData() else {
            os_log("❌ 画像読み込みエラー: %@", log: logger, type: .error, fileName)
            return nil
        }

        return INImage(imageData: imageData)
    }
}

// MARK: - OshiTrainerTemplate (Extension用の定義)

struct OshiTrainerTemplate: Codable {
    let id: UUID
    let name: String
    let characterImage: String
    let themeColor: String
    let homeImageScale: Double
}
