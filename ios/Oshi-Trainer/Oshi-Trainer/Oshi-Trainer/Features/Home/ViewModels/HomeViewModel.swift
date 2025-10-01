import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var oshiTrainer: OshiTrainer
    @Published var currentDialogue: String
    @Published var oshiLevel: Int

    private let dataService: DataServiceProtocol

    init(dataService: DataServiceProtocol = MockDataService.shared) {
        self.dataService = dataService
        let trainer = dataService.getOshiTrainer()
        self.oshiTrainer = trainer
        self.currentDialogue = trainer.currentDialogue
        self.oshiLevel = trainer.level
    }

    func loadTrainerData() {
        let trainer = dataService.getOshiTrainer()
        self.oshiTrainer = trainer
        self.currentDialogue = trainer.currentDialogue
        self.oshiLevel = trainer.level
    }

    func updateDialogue() {
        let dialogues = [
            "今日もトレーニング頑張ろう！💪",
            "一緒に成長していこうね！✨",
            "あなたなら絶対できる！",
            "休憩も大切だよ😊",
            "素晴らしい！その調子！🎉"
        ]
        currentDialogue = dialogues.randomElement() ?? dialogues[0]
    }
}
