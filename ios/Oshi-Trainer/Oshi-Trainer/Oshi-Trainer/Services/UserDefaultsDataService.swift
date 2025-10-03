import Foundation

/// UserDefaultsを使用したデータ永続化サービス
class UserDefaultsDataService: DataServiceProtocol {
    // MARK: - Properties

    private let trainerTemplatesKey = "trainerTemplates"

    // MARK: - DataServiceProtocol (既存メソッド)

    func getOshiTrainer() -> OshiTrainer {
        // デフォルトトレーナーを返す（後方互換性）
        var trainer = DefaultOshiTrainerData.oshiAi
        trainer.currentDialogue = DialogueTemplateProvider.getDialogue(for: .greeting)
        return trainer
    }

    func getLevelData() -> (level: Int, experience: Int, achievements: [Achievement]) {
        // モックデータを返す（後方互換性）
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

    // MARK: - トレーナーテンプレート管理

    func getAllTrainerTemplates() -> [OshiTrainerTemplate] {
        // UserDefaultsからデータを取得
        guard let data = UserDefaults.standard.data(forKey: trainerTemplatesKey) else {
            // データが存在しない場合はデフォルトトレーナーのみを返す
            return [DefaultOshiTrainerData.oshiAiTemplate]
        }

        // JSONデコード
        let decoder = JSONDecoder()
        do {
            let templates = try decoder.decode([OshiTrainerTemplate].self, from: data)
            return templates
        } catch {
            print("❌ トレーナーテンプレートのデコードエラー: \(error)")
            // デコード失敗時はデフォルトトレーナーのみを返す
            return [DefaultOshiTrainerData.oshiAiTemplate]
        }
    }

    func saveTrainerTemplate(_ template: OshiTrainerTemplate) -> Result<Void, DataServiceError> {
        // 既存のテンプレートを取得
        var templates = getAllTrainerTemplates()

        // 既存のテンプレートと同じIDがあれば更新、なければ追加
        if let index = templates.firstIndex(where: { $0.id == template.id }) {
            templates[index] = template
        } else {
            templates.append(template)
        }

        // JSONエンコード
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(templates)
            UserDefaults.standard.set(data, forKey: trainerTemplatesKey)
            print("✅ トレーナーテンプレートを保存しました: \(template.name)")
            return .success(())
        } catch {
            print("❌ トレーナーテンプレートのエンコードエラー: \(error)")
            return .failure(.encodingFailed)
        }
    }

    func getTrainerTemplate(by id: UUID) -> OshiTrainerTemplate? {
        let templates = getAllTrainerTemplates()
        return templates.first(where: { $0.id == id })
    }
}
