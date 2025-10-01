import Foundation

enum TrainingCategory: String, CaseIterable {
    case pushup = "腕立て伏せ"
    case squat = "スクワット"
    case plank = "プランク"
    case running = "ランニング"
}

enum CompletionStatus {
    case completed
    case inProgress
    case cancelled
}

struct TrainingSession: Identifiable {
    let id: UUID
    let date: Date
    let category: TrainingCategory
    let durationMinutes: Int
    let completionStatus: CompletionStatus

    init(
        id: UUID = UUID(),
        date: Date,
        category: TrainingCategory,
        durationMinutes: Int,
        completionStatus: CompletionStatus
    ) {
        self.id = id
        self.date = date
        self.category = category
        self.durationMinutes = durationMinutes
        self.completionStatus = completionStatus
    }
}
