import Foundation

struct OshiTrainer: Identifiable {
    let id: UUID
    var name: String
    var level: Int // >= 1
    var experience: Int // >= 0
    var imageName: String // アセット名
    var currentDialogue: String

    init(
        id: UUID = UUID(),
        name: String,
        level: Int,
        experience: Int,
        imageName: String,
        currentDialogue: String
    ) {
        self.id = id
        self.name = name
        self.level = max(1, level) // レベルは最低1
        self.experience = max(0, experience) // 経験値は最低0
        self.imageName = imageName
        self.currentDialogue = currentDialogue
    }
}
