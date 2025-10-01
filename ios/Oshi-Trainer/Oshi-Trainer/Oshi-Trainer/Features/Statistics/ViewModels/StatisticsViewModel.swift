import Foundation
import Combine

class StatisticsViewModel: ObservableObject {
    @Published var monthlyStats: [MonthlyStatistic]
    @Published var categoryStats: [CategoryStatistic]

    private let dataService: DataServiceProtocol

    init(dataService: DataServiceProtocol = MockDataService.shared) {
        self.dataService = dataService
        let stats = dataService.getStatistics()
        self.monthlyStats = stats.monthly
        self.categoryStats = stats.category
    }

    func loadStatistics() {
        let stats = dataService.getStatistics()
        self.monthlyStats = stats.monthly
        self.categoryStats = stats.category
    }

    func filterByMonth(month: Int) {
        // 将来的な実装：月別フィルタリング
        loadStatistics()
    }

    func filterByCategory(category: String) {
        // 将来的な実装：種目別フィルタリング
        loadStatistics()
    }

    var totalSessions: Int {
        categoryStats.reduce(0) { $0 + $1.totalSessions }
    }

    var totalDurationMinutes: Int {
        categoryStats.reduce(0) { $0 + $1.totalDurationMinutes }
    }
}
