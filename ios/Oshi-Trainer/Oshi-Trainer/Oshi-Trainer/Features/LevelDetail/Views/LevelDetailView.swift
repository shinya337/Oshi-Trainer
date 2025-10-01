import SwiftUI

struct LevelDetailView: View {
    @StateObject private var viewModel = LevelDetailViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.oshiBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // レベル表示
                        levelCard

                        // 経験値表示
                        experienceCard

                        // 称号リスト
                        achievementsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("推しレベル")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") {
                        dismiss()
                    }
                    .foregroundColor(.oshiGreen)
                }
            }
        }
    }

    // MARK: - Level Card
    private var levelCard: some View {
        VStack(spacing: 16) {
            Text("現在のレベル")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.oshiTextSecondary)

            HStack(spacing: 8) {
                Text("Lv.")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.oshiTextSecondary)
                Text("\(viewModel.currentLevel)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundColor(.oshiGreen)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.oshiBackgroundSecondary)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    // MARK: - Experience Card
    private var experienceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("獲得経験値")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.oshiTextPrimary)

            HStack(alignment: .lastTextBaseline, spacing: 8) {
                Text("\(viewModel.totalExperience)")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.oshiGreen)
                Text("EXP")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.oshiTextSecondary)
            }

            // プログレスバー（次のレベルまで）
            let progress = Double(viewModel.totalExperience % 300) / Double(300)

            VStack(alignment: .leading, spacing: 4) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 16)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [Color.oshiGreen, Color.oshiGreenLight],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress, height: 16)
                    }
                }
                .frame(height: 16)

                Text("次のレベルまで: \(300 - (viewModel.totalExperience % 300)) EXP")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.oshiTextSecondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.oshiBackgroundSecondary)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    // MARK: - Achievements Section
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("獲得した称号")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.oshiTextPrimary)

            VStack(spacing: 12) {
                ForEach(viewModel.unlockedAchievements) { achievement in
                    achievementRow(achievement)
                }
            }
        }
    }

    private func achievementRow(_ achievement: Achievement) -> some View {
        HStack(spacing: 16) {
            Image(systemName: achievement.iconName)
                .font(.system(size: 32))
                .foregroundColor(.oshiAccent)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(Color.oshiAccent.opacity(0.2))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.oshiTextPrimary)

                Text(achievement.description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.oshiTextSecondary)

                if let unlockedDate = achievement.unlockedDate {
                    Text(unlockedDate, style: .date)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(.oshiTextSecondary)
                }
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.oshiBackgroundSecondary)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    LevelDetailView()
}
