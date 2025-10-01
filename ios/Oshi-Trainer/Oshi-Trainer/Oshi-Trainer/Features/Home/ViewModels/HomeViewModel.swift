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
        updateDialogue(for: .encouragement)
    }

    func updateDialogue(for category: DialogueTemplateProvider.DialogueCategory) {
        currentDialogue = DialogueTemplateProvider.getDialogue(for: category)
    }
}
