import Foundation

/// 通知関連のエラー型
enum NotificationError: Error {
    case permissionDenied
    case schedulingFailed
    case invalidTrainerData
    case imageLoadFailed
    case intentCreationFailed
    case unknownError(Error)

    var localizedDescription: String {
        switch self {
        case .permissionDenied:
            return "通知権限が許可されていません"
        case .schedulingFailed:
            return "通知のスケジューリングに失敗しました"
        case .invalidTrainerData:
            return "トレーナーデータが不正です"
        case .imageLoadFailed:
            return "画像の読み込みに失敗しました"
        case .intentCreationFailed:
            return "INSendMessageIntentの作成に失敗しました"
        case .unknownError(let error):
            return "不明なエラー: \(error.localizedDescription)"
        }
    }
}
