import SwiftUI

struct TrainerDetailView: View {
    // MARK: - Properties
    let trainer: OshiTrainer
    let template: OshiTrainerTemplate
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color.oshiBackground
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    // タイトル
                    Text("トレーナー詳細")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color.oshiThemeColor(from: template.themeColor))
                        .padding(.top, 32)

                    // キャラクター画像（丸アイコン）
                    characterIconView

                    // 詳細情報
                    detailsView

                    Spacer()

                    // 閉じるボタン
                    closeButton
                        .padding(.bottom, 32)
                }
                .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Subviews

    private var characterIconView: some View {
        Image.loadFromAssetOrFile(template.characterImage)
            .resizable()
            .scaledToFill()
            .scaleEffect(template.detailIconScale)
            .offset(y: template.detailIconOffsetY)
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.oshiThemeColor(from: template.themeColor), lineWidth: 4)
            )
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }

    private var detailsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            DetailRow(label: "名前", value: trainer.name)
            DetailRow(
                label: "イメージカラー",
                value: getColorDisplayName(template.themeColor),
                color: Color.oshiThemeColor(from: template.themeColor)
            )
            DetailRow(label: "一人称", value: template.firstPerson)
            DetailRow(label: "呼び方", value: template.secondPerson)
            DetailRow(label: "性格", value: template.personalityType.displayName)
            DetailRow(label: "ボイス", value: template.characterVoice)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.oshiBackgroundSecondary)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }

    private var closeButton: some View {
        Button("閉じる") {
            dismiss()
        }
        .font(.system(size: 18, weight: .semibold, design: .rounded))
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.oshiThemeColor(from: template.themeColor))
        .cornerRadius(12)
    }

    /// 色の表示名を取得
    private func getColorDisplayName(_ colorId: String) -> String {
        switch colorId {
        case "pink": return "ピンク"
        case "blue": return "ブルー"
        case "green": return "グリーン"
        case "orange": return "オレンジ"
        case "purple": return "パープル"
        default: return "ピンク"
        }
    }
}

// MARK: - Detail Row Component

private struct DetailRow: View {
    let label: String
    let value: String
    var color: Color? = nil

    var body: some View {
        HStack(alignment: .center) {
            Text(label)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.oshiTextSecondary)

            Spacer()

            if let color = color {
                HStack(spacing: 8) {
                    Circle()
                        .fill(color)
                        .frame(width: 24, height: 24)
                    Text(value)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.oshiTextPrimary)
                }
            } else {
                Text(value)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.oshiTextPrimary)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TrainerDetailView(
        trainer: DefaultOshiTrainerData.oshiAi,
        template: DefaultOshiTrainerData.oshiAiTemplate
    )
}
