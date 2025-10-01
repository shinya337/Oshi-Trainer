import Foundation

struct Achievement: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let iconName: String
    let isUnlocked: Bool
    let unlockedDate: Date?

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        iconName: String,
        isUnlocked: Bool,
        unlockedDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.isUnlocked = isUnlocked
        self.unlockedDate = isUnlocked ? unlockedDate : nil
    }
}
