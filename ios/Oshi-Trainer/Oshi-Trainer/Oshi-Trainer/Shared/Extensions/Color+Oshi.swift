import SwiftUI

extension Color {
    // ベースカラー（70%）: 白と青みがかったグレー
    static let oshiBackground = Color(white: 0.95)
    static let oshiBackgroundSecondary = Color.white

    // メインカラー（25%）: 緑色（競馬場の芝生を連想）
    static let oshiGreen = Color.green
    static let oshiGreenLight = Color.green.opacity(0.8)

    // ピンクカラー（推乃 愛のデフォルトテーマカラー）
    static let oshiPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let oshiPinkLight = Color(red: 1.0, green: 0.6, blue: 0.75)

    // アクセントカラー（5%）: オレンジまたはピンク
    static let oshiAccent = Color.orange
    static let oshiAccentSecondary = Color.pink

    // テキストカラー
    static let oshiTextPrimary = Color.black
    static let oshiTextSecondary = Color.gray

    // MARK: - Dynamic Theme Color

    /// テーマカラー文字列からColorへの変換
    /// - Parameter identifier: テーマカラー識別子（pink, blue, green, orange, purple）
    /// - Returns: 対応するColor（不正な識別子の場合はデフォルトカラー）
    static func oshiThemeColor(from identifier: String) -> Color {
        switch identifier.lowercased() {
        case "pink":
            return Color(red: 1.0, green: 0.4, blue: 0.6)
        case "blue":
            return Color(red: 0.3, green: 0.6, blue: 1.0)
        case "green":
            return Color(red: 0.2, green: 0.8, blue: 0.4)
        case "orange":
            return Color(red: 1.0, green: 0.6, blue: 0.2)
        case "purple":
            return Color(red: 0.7, green: 0.4, blue: 1.0)
        default:
            // 不正な識別子の場合はデフォルトカラー（pink）
            return Color(red: 1.0, green: 0.4, blue: 0.6)
        }
    }

    /// テーマカラーの薄いバリエーション（透明度0.6）
    /// - Parameter identifier: テーマカラー識別子（pink, blue, green, orange, purple）
    /// - Returns: 透明度0.6の対応するColor
    static func oshiThemeColorLight(from identifier: String) -> Color {
        return oshiThemeColor(from: identifier).opacity(0.6)
    }
}
