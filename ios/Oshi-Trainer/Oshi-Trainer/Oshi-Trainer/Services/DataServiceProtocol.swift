import Foundation

/// データサービスのエラー型
enum DataServiceError: Error {
    case encodingFailed
    case decodingFailed
    case saveFailed
}

protocol DataServiceProtocol {
    func getOshiTrainer() -> OshiTrainer
    func getLevelData() -> (level: Int, experience: Int, achievements: [Achievement])
    func getStatistics() -> (monthly: [MonthlyStatistic], category: [CategoryStatistic])

    // MARK: - トレーナーテンプレート管理

    /// 全トレーナーテンプレートを取得
    func getAllTrainerTemplates() -> [OshiTrainerTemplate]

    /// トレーナーテンプレートを保存
    func saveTrainerTemplate(_ template: OshiTrainerTemplate) -> Result<Void, DataServiceError>

    /// ID指定でトレーナーテンプレートを取得
    func getTrainerTemplate(by id: UUID) -> OshiTrainerTemplate?
}
