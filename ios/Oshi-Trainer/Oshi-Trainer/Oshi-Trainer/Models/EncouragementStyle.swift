import Foundation

/// 応援スタイル
enum EncouragementStyle: String, CaseIterable, Codable {
    case strict = "strict"      // 厳しめ
    case gentle = "gentle"      // 優しめ
    case balanced = "balanced"  // バランス型

    /// 応援スタイルの表示名
    var displayName: String {
        switch self {
        case .strict: return "厳しめ"
        case .gentle: return "優しめ"
        case .balanced: return "バランス型"
        }
    }

    /// 厳しさの重み（0.0〜1.0）
    /// トレーニング中のフィードバック選択やLLMプロンプトに使用
    var strictnessWeight: Double {
        switch self {
        case .strict: return 0.8
        case .gentle: return 0.2
        case .balanced: return 0.5
        }
    }
}
