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
                    // キャラクター画像（丸アイコン）
                    characterIconView
                        .padding(.top, 32)

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
        Image(template.characterImage)
            .resizable()
            .scaledToFill()
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
                value: "ピンク",
                color: Color.oshiThemeColor(from: template.themeColor)
            )
            DetailRow(label: "一人称", value: template.firstPerson)
            DetailRow(label: "呼び方", value: template.secondPerson)
            DetailRow(label: "性格", value: template.personalityDescription)
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
        .buttonStyle(OshiButtonStyle())
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
