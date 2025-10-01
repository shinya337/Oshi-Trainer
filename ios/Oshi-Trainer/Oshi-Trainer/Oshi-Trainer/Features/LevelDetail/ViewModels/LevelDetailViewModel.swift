import Foundation
import Combine

class LevelDetailViewModel: ObservableObject {
    @Published var currentLevel: Int
    @Published var totalExperience: Int
    @Published var achievements: [Achievement]

    private let dataService: DataServiceProtocol

    init(dataService: DataServiceProtocol = MockDataService.shared) {
        self.dataService = dataService
        let levelData = dataService.getLevelData()
        self.currentLevel = levelData.level
        self.totalExperience = levelData.experience
        self.achievements = levelData.achievements
    }

    func loadLevelData() {
        let levelData = dataService.getLevelData()
        self.currentLevel = levelData.level
        self.totalExperience = levelData.experience
        self.achievements = levelData.achievements
    }

    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isUnlocked }
    }
}
