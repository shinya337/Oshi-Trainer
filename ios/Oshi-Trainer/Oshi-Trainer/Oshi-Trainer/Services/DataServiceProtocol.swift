import Foundation

protocol DataServiceProtocol {
    func getOshiTrainer() -> OshiTrainer
    func getLevelData() -> (level: Int, experience: Int, achievements: [Achievement])
    func getStatistics() -> (monthly: [MonthlyStatistic], category: [CategoryStatistic])
}
