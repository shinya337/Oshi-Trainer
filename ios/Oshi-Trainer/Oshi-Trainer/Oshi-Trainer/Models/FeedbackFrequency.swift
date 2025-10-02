import Foundation

/// フィードバック頻度
enum FeedbackFrequency: String, CaseIterable, Codable {
    case high = "high"      // 高頻度
    case medium = "medium"  // 中頻度
    case low = "low"        // 低頻度

    /// フィードバック頻度の表示名
    var displayName: String {
        switch self {
        case .high: return "高頻度"
        case .medium: return "中頻度"
        case .low: return "低頻度"
        }
    }

    /// レップ間隔（何レップごとにフィードバックを出すか）
    var repInterval: Int {
        switch self {
        case .high: return 1    // 毎レップ
        case .medium: return 3  // 3レップごと
        case .low: return 5     // 5レップごと
        }
    }
}
