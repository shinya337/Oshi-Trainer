import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    var themeColor: String = "pink"

    var body: some View {
        ZStack {
            Color.oshiBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // 総合統計
                    overallStatsCard

                    // 月別統計
                    monthlyStatsSection

                    // 種目別統計
                    categoryStatsSection
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("統計")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color.oshiThemeColor(from: themeColor))
            }
        }
    }

    // MARK: - Overall Stats Card
    private var overallStatsCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("\(viewModel.totalSessions)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.oshiGreen)
                    Text("総セッション数")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.oshiTextSecondary)
                }

                Divider()
                    .frame(height: 60)

                VStack(spacing: 8) {
                    Text("\(viewModel.totalDurationMinutes)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.oshiAccent)
                    Text("総時間（分）")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.oshiTextSecondary)
                }
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.oshiBackgroundSecondary)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    // MARK: - Monthly Stats Section
    private var monthlyStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("月別統計")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.oshiTextPrimary)

            VStack(spacing: 12) {
                ForEach(viewModel.monthlyStats) { stat in
                    monthlyStatRow(stat)
                }
            }
        }
    }

    private func monthlyStatRow(_ stat: MonthlyStatistic) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(stat.month, style: .date)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.oshiTextPrimary)

                Spacer()

                Text("+\(stat.experienceGained) EXP")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.oshiGreen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.oshiGreen.opacity(0.2))
                    )
            }

            HStack(spacing: 24) {
                StatLabel(icon: "figure.run", value: "\(stat.totalSessions)", label: "セッション")
                StatLabel(icon: "clock.fill", value: "\(stat.totalDurationMinutes)", label: "分")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.oshiBackgroundSecondary)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    // MARK: - Category Stats Section
    private var categoryStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("種目別統計")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.oshiTextPrimary)

            VStack(spacing: 12) {
                ForEach(viewModel.categoryStats) { stat in
                    categoryStatRow(stat)
                }
            }
        }
    }

    private func categoryStatRow(_ stat: CategoryStatistic) -> some View {
        HStack(spacing: 16) {
            // カテゴリーアイコン
            ZStack {
                Circle()
                    .fill(categoryColor(stat.category).opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: categoryIcon(stat.category))
                    .font(.system(size: 24))
                    .foregroundColor(categoryColor(stat.category))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(stat.category.rawValue)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.oshiTextPrimary)

                HStack(spacing: 16) {
                    Label("\(stat.totalSessions)回", systemImage: "figure.run")
                    Label("\(stat.totalDurationMinutes)分", systemImage: "clock")
                }
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.oshiTextSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("平均")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(.oshiTextSecondary)
                Text(String(format: "%.1f分", stat.averageDuration))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.oshiGreen)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.oshiBackgroundSecondary)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    // MARK: - Helper Functions
    private func categoryIcon(_ category: TrainingCategory) -> String {
        switch category {
        case .pushup: return "figure.strengthtraining.traditional"
        case .squat: return "figure.strengthtraining.functional"
        case .plank: return "figure.core.training"
        case .running: return "figure.run"
        }
    }

    private func categoryColor(_ category: TrainingCategory) -> Color {
        switch category {
        case .pushup: return .oshiGreen
        case .squat: return .blue
        case .plank: return .oshiAccent
        case .running: return .oshiAccentSecondary
        }
    }
}

// MARK: - Stat Label Component
struct StatLabel: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
            Text("\(value) \(label)")
                .font(.system(size: 14, weight: .regular, design: .rounded))
        }
        .foregroundColor(.oshiTextSecondary)
    }
}

#Preview {
    NavigationStack {
        StatisticsView()
    }
}
