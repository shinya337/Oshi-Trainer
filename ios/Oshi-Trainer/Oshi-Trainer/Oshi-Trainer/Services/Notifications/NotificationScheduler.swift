import Foundation
import UserNotifications
import Intents
import UIKit

/// 通知スケジューリングプロトコル
protocol NotificationSchedulerProtocol {
    func scheduleNotification(
        trainer: OshiTrainerTemplate,
        message: String,
        deliveryTime: Date
    ) async -> Result<Void, NotificationError>

    func getPendingNotifications() async -> [UNNotificationRequest]
    func cancelNotification(id: String) async
    func cancelAllNotifications() async
}

/// 通知スケジューリングサービス
class NotificationScheduler: NotificationSchedulerProtocol {
    // MARK: - Properties

    private let notificationCenter = UNUserNotificationCenter.current()

    // MARK: - Public Methods

    /// 通知をスケジュールする
    func scheduleNotification(
        trainer: OshiTrainerTemplate,
        message: String,
        deliveryTime: Date
    ) async -> Result<Void, NotificationError> {
        // 通知権限を確認
        let settings = await notificationCenter.notificationSettings()
        guard settings.authorizationStatus == .authorized else {
            return .failure(.permissionDenied)
        }

        // iOS 15以上かチェック
        if #available(iOS 15.0, *) {
            return await scheduleCommunicationNotification(
                trainer: trainer,
                message: message,
                deliveryTime: deliveryTime
            )
        } else {
            // iOS 14以下の場合は従来形式の通知
            return await scheduleLegacyNotification(
                trainer: trainer,
                message: message,
                deliveryTime: deliveryTime
            )
        }
    }

    /// 画像アタッチメント付き通知をスケジュール（iOS 15+）
    @available(iOS 15.0, *)
    private func scheduleCommunicationNotification(
        trainer: OshiTrainerTemplate,
        message: String,
        deliveryTime: Date
    ) async -> Result<Void, NotificationError> {
        let content = UNMutableNotificationContent()

        // INPersonを作成（通知アイコン用のスケールとオフセットを適用）
        // iconScale: 1.0 = 等倍、1.5 = 1.5倍拡大、0.8 = 0.8倍縮小
        // iconOffset: 正の値で下に、負の値で上に移動（ピクセル単位）
        let person = INPersonBuilder.createPerson(
            from: trainer,
            iconScale: 3.0,    // 3.0倍に拡大（調整可能）
            iconOffset: 130    // 130ピクセル上に移動（調整可能）
        )

        // INSendMessageIntentを作成
        let intent = INSendMessageIntent(
            recipients: nil,
            outgoingMessageType: .outgoingMessageText,
            content: message,
            speakableGroupName: INSpeakableString(spokenPhrase: trainer.name),
            conversationIdentifier: trainer.id.uuidString,
            serviceName: nil,
            sender: person,
            attachments: nil
        )

        // 画像を明示的に設定
        if let personImage = person.image {
            intent.setImage(personImage, forParameterNamed: \INSendMessageIntent.sender)
        }

        do {
            // INSendMessageIntentからUNNotificationContentを更新
            print("🔄 content.updating(from: intent)を実行...")
            let updatedContent = try content.updating(from: intent) as! UNMutableNotificationContent

            // title/bodyが空の場合は手動で設定（フォールバック）
            if updatedContent.title.isEmpty || updatedContent.body.isEmpty {
                print("⚠️ title/bodyが空です。手動で設定します")
                updatedContent.title = trainer.name
                updatedContent.body = message
            }

            // 基本情報を設定
            updatedContent.sound = .default
            updatedContent.interruptionLevel = .timeSensitive
            updatedContent.userInfo = [
                "trainerId": trainer.id.uuidString,
                "notificationId": UUID().uuidString,
                "category": "TRAINING_INVITATION"
            ]
            updatedContent.categoryIdentifier = "TRAINING_INVITATION"
            updatedContent.threadIdentifier = trainer.id.uuidString

            print("📝 通知内容: title=\(updatedContent.title), body=\(updatedContent.body)")

            // 配信時刻のトリガーを作成
            let timeInterval = deliveryTime.timeIntervalSinceNow
            let trigger: UNNotificationTrigger?

            // 60秒以内の場合はTimeIntervalトリガーを使用（テスト用）
            if timeInterval <= 60 {
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, timeInterval), repeats: false)
                print("⏰ TimeIntervalトリガー使用: \(max(1, timeInterval))秒後")
            } else {
                // 通常の配信時刻指定の場合はCalendarトリガーを使用
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: deliveryTime)
                trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                print("📅 Calendarトリガー使用")
            }

            // 通知リクエストを作成
            let notificationId = UUID().uuidString
            let request = UNNotificationRequest(
                identifier: notificationId,
                content: updatedContent,
                trigger: trigger
            )

            print("📤 通知を登録中: ID=\(notificationId)")

            // 通知を登録
            try await notificationCenter.add(request)
            print("✅ Communication Notification をスケジュールしました: \(trainer.name)")

            // 登録された通知を確認
            let pending = await notificationCenter.pendingNotificationRequests()
            print("📋 スケジュール済み通知数: \(pending.count)")

            return .success(())
        } catch {
            print("❌ Communication Notification作成エラー: \(error)")
            print("❌ エラー詳細: \(error.localizedDescription)")

            // フォールバック: 通常の画像添付通知
            print("⚠️ 通常の画像添付通知にフォールバック")
            return await scheduleLegacyNotification(trainer: trainer, message: message, deliveryTime: deliveryTime)
        }
    }

    /// 従来形式の通知をスケジュール（iOS 14以下）
    private func scheduleLegacyNotification(
        trainer: OshiTrainerTemplate,
        message: String,
        deliveryTime: Date
    ) async -> Result<Void, NotificationError> {
        let content = UNMutableNotificationContent()
        content.title = trainer.name
        content.body = message
        content.sound = .default

        // userInfoにトレーナー情報を追加
        content.userInfo = [
            "trainerId": trainer.id.uuidString,
            "notificationId": UUID().uuidString,
            "category": "TRAINING_INVITATION"
        ]

        // カテゴリを設定
        content.categoryIdentifier = "TRAINING_INVITATION"

        // 配信時刻のトリガーを作成
        let timeInterval = deliveryTime.timeIntervalSinceNow
        let trigger: UNNotificationTrigger?

        // 5秒以内の場合はTimeIntervalトリガーを使用（テスト用）
        if timeInterval <= 60 {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, timeInterval), repeats: false)
        } else {
            // 通常の配信時刻指定の場合はCalendarトリガーを使用
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: deliveryTime)
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        }

        // 通知リクエストを作成
        let notificationId = UUID().uuidString
        let request = UNNotificationRequest(
            identifier: notificationId,
            content: content,
            trigger: trigger
        )

        do {
            // 通知を登録
            try await notificationCenter.add(request)
            print("✅ 通知をスケジュールしました: \(trainer.name)")
            return .success(())
        } catch {
            print("❌ 通知スケジューリングエラー: \(error)")
            return .failure(.schedulingFailed)
        }
    }

    /// スケジュール済み通知を取得
    func getPendingNotifications() async -> [UNNotificationRequest] {
        return await notificationCenter.pendingNotificationRequests()
    }

    /// 通知をキャンセル
    func cancelNotification(id: String) async {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        print("✅ 通知をキャンセルしました: \(id)")
    }

    /// 全通知をキャンセル
    func cancelAllNotifications() async {
        notificationCenter.removeAllPendingNotificationRequests()
        print("✅ 全通知をキャンセルしました")
    }

    // MARK: - Helper Methods

    /// トレーナー画像を読み込む
    private func loadTrainerImage(characterImage: String) -> UIImage? {
        // App Groupコンテナから画像を読み込む
        guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yourcompany.VirtualTrainer") else {
            print("⚠️ App Groupコンテナが利用できません")
            // Assetsから読み込みを試行
            return UIImage(named: characterImage)
        }

        let imageFileName = characterImage.hasSuffix(".png") ? characterImage : "\(characterImage).png"
        let imagePath = appGroupURL
            .appendingPathComponent("TrainerImages")
            .appendingPathComponent(imageFileName)

        if let image = UIImage(contentsOfFile: imagePath.path) {
            return image
        }

        // App Groupから読み込めない場合はAssetsから試行
        return UIImage(named: characterImage)
    }

    /// UIImageからUNNotificationAttachmentを作成
    private func createAttachment(from image: UIImage) -> UNNotificationAttachment? {
        guard let imageData = image.pngData() else {
            print("❌ 画像データの変換に失敗しました")
            return nil
        }

        // 一時ファイルとして保存
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName = "\(UUID().uuidString).png"
        let fileURL = tempDirectory.appendingPathComponent(fileName)

        do {
            try imageData.write(to: fileURL)
            let attachment = try UNNotificationAttachment(identifier: fileName, url: fileURL, options: nil)
            return attachment
        } catch {
            print("❌ UNNotificationAttachment作成エラー: \(error)")
            return nil
        }
    }
}
