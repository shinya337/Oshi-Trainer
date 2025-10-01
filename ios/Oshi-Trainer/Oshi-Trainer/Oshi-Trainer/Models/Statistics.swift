import Foundation

struct MonthlyStatistic: Identifiable {
    let id: UUID
    let month: Date
    let totalSessions: Int
    let totalDurationMinutes: Int
    let experienceGained: Int

    init(
        id: UUID = UUID(),
        month: Date,
        totalSessions: Int,
        totalDurationMinutes: Int,
        experienceGained: Int
    ) {
        self.id = id
        self.month = month
        self.totalSessions = totalSessions
        self.totalDurationMinutes = totalDurationMinutes
        self.experienceGained = experienceGained
    }
}

struct CategoryStatistic: Identifiable {
    let id: UUID
    let category: TrainingCategory
    let totalSessions: Int
    let totalDurationMinutes: Int
    let averageDuration: Double

    init(
        id: UUID = UUID(),
        category: TrainingCategory,
        totalSessions: Int,
        totalDurationMinutes: Int
    ) {
        self.id = id
        self.category = category
        self.totalSessions = totalSessions
        self.totalDurationMinutes = totalDurationMinutes
        self.averageDuration = totalSessions > 0 ? Double(totalDurationMinutes) / Double(totalSessions) : 0.0
    }
}
