import SwiftUI

struct TrainingPopupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showCamera = false
    @State private var selectedCategory: TrainingCategory = .pushup

    var body: some View {
        NavigationStack {
            ZStack {
                Color.oshiBackground
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    // タイトル
                    Text("トレーニング")
                        .oshiTitleStyle()
                        .foregroundColor(.oshiTextPrimary)
                        .padding(.top, 32)

                    // 種目選択
                    categorySelector

                    // 種目説明
                    categoryDescription

                    // 推奨時間
                    recommendedTime

                    Spacer()

                    // トレーニング開始ボタン
                    Button(action: {
                        showCamera = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "camera.fill")
                            Text("トレーニング開始")
                        }
                        .oshiButtonLargeStyle()
                    }
                    .buttonStyle(OshiButtonStyle())

                    // 閉じるボタン
                    Button("キャンセル") {
                        dismiss()
                    }
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.oshiTextSecondary)
                    .padding(.bottom, 32)
                }
                .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showCamera) {
                CameraView()
            }
        }
    }

    // MARK: - Category Selector
    private var categorySelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("種目を選択")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.oshiTextPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(TrainingCategory.allCases, id: \.self) { category in
                        categoryButton(category)
                    }
                }
            }
        }
    }

    private func categoryButton(_ category: TrainingCategory) -> some View {
        Button(action: {
            selectedCategory = category
        }) {
            Text(category.rawValue)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(selectedCategory == category ? Color.oshiGreen : Color.oshiBackgroundSecondary)
                )
                .foregroundColor(selectedCategory == category ? .white : .oshiTextPrimary)
        }
    }

    // MARK: - Category Description
    private var categoryDescription: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("説明")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.oshiTextPrimary)

            Text(getDescription(for: selectedCategory))
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.oshiTextSecondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.oshiBackgroundSecondary)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
        }
    }

    // MARK: - Recommended Time
    private var recommendedTime: some View {
        HStack {
            Image(systemName: "clock.fill")
                .font(.system(size: 24))
                .foregroundColor(.oshiGreen)

            Text("推奨時間:")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.oshiTextPrimary)

            Text(getRecommendedTime(for: selectedCategory))
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.oshiGreen)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.oshiBackgroundSecondary)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    // MARK: - Helper Functions
    private func getDescription(for category: TrainingCategory) -> String {
        switch category {
        case .pushup:
            return "胸、肩、腕の筋肉を鍛える基本的な自重トレーニング。正しいフォームで行うことが重要です。"
        case .squat:
            return "下半身全体を鍛える効果的なトレーニング。膝がつま先より前に出ないように注意しましょう。"
        case .plank:
            return "体幹を鍛えるトレーニング。背中をまっすぐ保ち、呼吸を止めないことがポイントです。"
        case .running:
            return "有酸素運動で全身の持久力を高めます。自分のペースで無理なく続けましょう。"
        }
    }

    private func getRecommendedTime(for category: TrainingCategory) -> String {
        switch category {
        case .pushup:
            return "10回 × 3セット"
        case .squat:
            return "15回 × 3セット"
        case .plank:
            return "30秒 × 3セット"
        case .running:
            return "20分"
        }
    }
}

#Preview {
    TrainingPopupView()
}
