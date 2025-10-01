import Foundation

class MockDataService: DataServiceProtocol {
    static let shared = MockDataService()

    private init() {}

    func getOshiTrainer() -> OshiTrainer {
        return OshiTrainer(
            name: "推しトレーナー",
            level: 10,
            experience: 2450,
            imageName: "person.fill", // SF Symbol（プレースホルダー）
            currentDialogue: "今日もトレーニング頑張ろう！💪"
        )
    }

    func getLevelData() -> (level: Int, experience: Int, achievements: [Achievement]) {
        let achievements = [
            Achievement(
                title: "初めての一歩",
                description: "最初のトレーニングを完了しました",
                iconName: "star.fill",
                isUnlocked: true,
                unlockedDate: Date().addingTimeInterval(-86400 * 30)
            ),
            Achievement(
                title: "継続は力なり",
                description: "7日間連続でトレーニングを実施しました",
                iconName: "flame.fill",
                isUnlocked: true,
                unlockedDate: Date().addingTimeInterval(-86400 * 10)
            ),
            Achievement(
                title: "トレーニングマスター",
                description: "100回のトレーニングを完了しました",
                iconName: "trophy.fill",
                isUnlocked: true,
                unlockedDate: Date().addingTimeInterval(-86400 * 2)
            ),
            Achievement(
                title: "鉄人への道",
                description: "300回のトレーニングを完了しました",
                iconName: "medal.fill",
                isUnlocked: false,
                unlockedDate: nil
            ),
            Achievement(
                title: "レジェンド",
                description: "1000回のトレーニングを完了しました",
                iconName: "crown.fill",
                isUnlocked: false,
                unlockedDate: nil
            )
        ]

        return (level: 10, experience: 2450, achievements: achievements)
    }

    func getStatistics() -> (monthly: [MonthlyStatistic], category: [CategoryStatistic]) {
        let calendar = Calendar.current
        let now = Date()

        // 月別統計（過去3ヶ月）
        let monthlyStats = [
            MonthlyStatistic(
                month: calendar.date(byAdding: .month, value: -2, to: now)!,
                totalSessions: 18,
                totalDurationMinutes: 360,
                experienceGained: 720
            ),
            MonthlyStatistic(
                month: calendar.date(byAdding: .month, value: -1, to: now)!,
                totalSessions: 22,
                totalDurationMinutes: 440,
                experienceGained: 880
            ),
            MonthlyStatistic(
                month: now,
                totalSessions: 25,
                totalDurationMinutes: 500,
                experienceGained: 1000
            )
        ]

        // 種目別統計
        let categoryStats = [
            CategoryStatistic(
                category: .pushup,
                totalSessions: 20,
                totalDurationMinutes: 300
            ),
            CategoryStatistic(
                category: .squat,
                totalSessions: 18,
                totalDurationMinutes: 270
            ),
            CategoryStatistic(
                category: .plank,
                totalSessions: 15,
                totalDurationMinutes: 225
            ),
            CategoryStatistic(
                category: .running,
                totalSessions: 12,
                totalDurationMinutes: 360
            )
        ]

        return (monthly: monthlyStats, category: categoryStats)
    }
}
