import SwiftUI
import Combine
import UserNotifications

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var notificationTestResult: String = ""
    @Published var showNotificationAlert: Bool = false

    private let notificationScheduler = NotificationScheduler()
    private let dataService = UserDefaultsDataService()
    private var imagePersistence: ImagePersistenceService?

    init() {
        // ImagePersistenceServiceを初期化
        do {
            imagePersistence = try ImagePersistenceService()
        } catch {
            print("❌ ImagePersistenceServiceの初期化エラー: \(error)")
        }
    }

    /// テスト通知を送信
    /// - Parameter trainer: 通知を送信するトレーナー（nilの場合は最初のトレーナーを使用）
    func sendTestNotification(trainer: OshiTrainerTemplate? = nil) {
        Task {
            // 通知権限を確認・リクエスト
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            if settings.authorizationStatus != .authorized {
                // 通知権限をリクエスト
                do {
                    let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
                    if !granted {
                        notificationTestResult = "通知権限が許可されていません"
                        showNotificationAlert = true
                        return
                    }
                } catch {
                    notificationTestResult = "通知権限のリクエストに失敗しました"
                    showNotificationAlert = true
                    return
                }
            }

            // 使用するトレーナーを決定
            let targetTrainer: OshiTrainerTemplate
            if let trainer = trainer {
                targetTrainer = trainer
            } else {
                // トレーナーが指定されていない場合は最初のトレーナーを取得
                let templates = dataService.getAllTrainerTemplates()
                guard let firstTrainer = templates.first else {
                    notificationTestResult = "トレーナーが見つかりません"
                    showNotificationAlert = true
                    return
                }
                targetTrainer = firstTrainer
            }

            // Assetsの画像をApp Groupコンテナにコピー（デフォルトトレーナーの場合のみ）
            if let imagePersistence = imagePersistence {
                // UUIDでない場合（デフォルトトレーナー）のみAssetsからコピー
                if UUID(uuidString: targetTrainer.characterImage) == nil {
                    if !imagePersistence.imageExists(fileName: "\(targetTrainer.characterImage).png") {
                        _ = imagePersistence.copyAssetImageToAppGroup(assetName: targetTrainer.characterImage)
                    }
                }
                // ユーザー作成トレーナーの画像は既にApp Groupコンテナに保存されている
            }

            // App Groupにトレーナーデータを同期
            dataService.syncTrainerTemplatesToAppGroup()
            dataService.saveSelectedTrainerId(targetTrainer.id)

            // 5秒後に通知を配信
            let deliveryTime = Date().addingTimeInterval(5)
            let result = await notificationScheduler.scheduleNotification(
                trainer: targetTrainer,
                message: "テスト通知です！一緒にトレーニングしませんか？",
                deliveryTime: deliveryTime
            )

            switch result {
            case .success:
                notificationTestResult = "5秒後にテスト通知が届きます\nトレーナー: \(targetTrainer.name)"
                showNotificationAlert = true
            case .failure(let error):
                notificationTestResult = "通知の送信に失敗しました: \(error.localizedDescription)"
                showNotificationAlert = true
            }
        }
    }
}
