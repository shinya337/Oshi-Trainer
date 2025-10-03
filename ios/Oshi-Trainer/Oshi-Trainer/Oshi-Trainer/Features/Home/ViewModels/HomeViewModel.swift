import Foundation
import Combine

class HomeViewModel: ObservableObject {
    // MARK: - Published Properties

    /// 推しトレーナーリスト（デフォルトトレーナー + 推し追加プレースホルダー）
    @Published var trainers: [OshiTrainer] = []

    /// 推しトレーナーテンプレートリスト
    @Published var templates: [OshiTrainerTemplate] = []

    /// 現在選択中のトレーナーインデックス
    @Published var currentTrainerIndex: Int = 0

    /// 現在のセリフ
    @Published var currentDialogue: String = ""

    // MARK: - Computed Properties

    /// 実際のトレーナー数（無限ループ用配列の1グループ分）
    var actualTrainerCount: Int {
        return trainers.count / 3
    }

    /// 現在選択中のトレーナー
    var currentTrainer: OshiTrainer {
        let actualIndex = currentTrainerIndex % actualTrainerCount
        return trainers.indices.contains(actualIndex) ? trainers[actualIndex] : trainers[0]
    }

    /// 現在選択中のトレーナーテンプレート
    var currentTemplate: OshiTrainerTemplate {
        let actualIndex = currentTrainerIndex % actualTrainerCount
        return templates.indices.contains(actualIndex) ? templates[actualIndex] : templates[0]
    }

    /// 現在のレベル（後方互換性のため）
    var oshiLevel: Int {
        currentTrainer.level
    }

    /// 現在のトレーナー（後方互換性のため）
    var oshiTrainer: OshiTrainer {
        currentTrainer
    }

    /// 現在のテンプレート（後方互換性のため）
    var oshiTemplate: OshiTrainerTemplate {
        currentTemplate
    }

    // MARK: - Private Properties

    private let dataService: DataServiceProtocol

    /// 推し追加プレースホルダー専用のUUID
    private let addPlaceholderId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    // MARK: - Initialization

    init(dataService: DataServiceProtocol = MockDataService.shared) {
        self.dataService = dataService
        loadTrainers()
    }

    // MARK: - Public Methods

    /// 推しトレーナーリストの読み込み
    func loadTrainers() {
        // デフォルトトレーナー「推乃 愛」
        let defaultTrainer = dataService.getOshiTrainer()
        let defaultTemplate = DefaultOshiTrainerData.oshiAiTemplate

        // 推し追加プレースホルダー
        let addPlaceholder = OshiTrainer(
            id: addPlaceholderId,
            name: "推し追加",
            level: 1,
            experience: 0,
            imageName: "oshi_create",
            currentDialogue: "新しい推しを作成しよう！"
        )
        let addPlaceholderTemplate = OshiTrainerTemplate(
            id: addPlaceholderId,
            name: "推し追加",
            themeColor: "pink",
            characterImage: "oshi_create",
            personalityType: .cheerful,
            firstPerson: "",
            secondPerson: "",
            personalityDescription: "",
            characterVoice: ""
        )

        // 無限ループ用に配列を3倍にする（左グループ、中央グループ、右グループ）
        let baseTrainers = [defaultTrainer, addPlaceholder]
        let baseTemplates = [defaultTemplate, addPlaceholderTemplate]

        trainers = baseTrainers + baseTrainers + baseTrainers
        templates = baseTemplates + baseTemplates + baseTemplates

        // 中央グループから開始（インデックス = baseTrainers.count）
        currentTrainerIndex = baseTrainers.count
        currentDialogue = DialogueTemplateProvider.getDialogue(for: .greeting)
    }

    /// 推し追加プレースホルダーかどうかを判定
    func isAddPlaceholder(_ trainer: OshiTrainer) -> Bool {
        trainer.id == addPlaceholderId
    }

    /// トレーナーデータの再読み込み（後方互換性のため）
    func loadTrainerData() {
        loadTrainers()
    }

    /// セリフの更新（デフォルト：応援）
    func updateDialogue() {
        updateDialogue(for: .encouragement)
    }

    /// セリフの更新（カテゴリ指定）
    func updateDialogue(for category: DialogueTemplateProvider.DialogueCategory) {
        currentDialogue = DialogueTemplateProvider.getDialogue(for: category)
    }
}
