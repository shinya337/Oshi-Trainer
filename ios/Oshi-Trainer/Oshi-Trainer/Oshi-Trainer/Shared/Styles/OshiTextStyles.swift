import SwiftUI

struct OshiTextStyles {
    // 数値表示用（26-28pt）
    static let numberStyle = Font.system(size: 28, weight: .bold, design: .rounded)

    // メインボタン用（32-42pt）
    static let buttonLargeStyle = Font.system(size: 36, weight: .bold, design: .rounded)
    static let buttonMediumStyle = Font.system(size: 32, weight: .bold, design: .rounded)

    // タイトル用
    static let titleStyle = Font.system(size: 24, weight: .bold, design: .rounded)

    // 一般テキスト
    static let bodyStyle = Font.system(size: 18, weight: .regular, design: .rounded)
    static let captionStyle = Font.system(size: 14, weight: .regular, design: .rounded)
}

extension View {
    func oshiNumberStyle() -> some View {
        self.font(OshiTextStyles.numberStyle)
    }

    func oshiButtonLargeStyle() -> some View {
        self.font(OshiTextStyles.buttonLargeStyle)
    }

    func oshiTitleStyle() -> some View {
        self.font(OshiTextStyles.titleStyle)
    }

    func oshiBodyStyle() -> some View {
        self.font(OshiTextStyles.bodyStyle)
    }
}
