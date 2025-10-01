import SwiftUI

extension Color {
    // ベースカラー（70%）: 白と青みがかったグレー
    static let oshiBackground = Color(white: 0.95)
    static let oshiBackgroundSecondary = Color.white

    // メインカラー（25%）: 緑色（競馬場の芝生を連想）
    static let oshiGreen = Color.green
    static let oshiGreenLight = Color.green.opacity(0.8)

    // ピンクカラー（推乃 愛のテーマカラー）
    static let oshiPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let oshiPinkLight = Color(red: 1.0, green: 0.6, blue: 0.75)

    // アクセントカラー（5%）: オレンジまたはピンク
    static let oshiAccent = Color.orange
    static let oshiAccentSecondary = Color.pink

    // テキストカラー
    static let oshiTextPrimary = Color.black
    static let oshiTextSecondary = Color.gray
}
