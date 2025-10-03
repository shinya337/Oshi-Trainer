import Foundation

/// 推しトレーナーのテンプレートモデル
/// 推し作成機能の基盤となる入力項目を保持
struct OshiTrainerTemplate: Identifiable, Codable {
    // MARK: - Properties

    /// 識別子
    let id: UUID

    // MARK: 基本プロフィール

    /// 推しの名前
    var name: String

    /// テーマカラー（pink, blue, green, orange, purple）
    var themeColor: String

    /// キャラクター画像名またはURL
    var characterImage: String

    // MARK: 性格・口調パラメータ

    /// 性格タイプ
    var personalityType: PersonalityType

    /// 一人称（例: うち、私、俺、僕）
    var firstPerson: String

    /// 二人称（ユーザーへの呼び方、例: あんた、あなた、君、お前）
    var secondPerson: String

    /// 性格説明（LLM統合時のプロンプト生成用）
    var personalityDescription: String

    // MARK: LLM統合パラメータ（非リアルタイム用途）

    /// プロンプト指示（LLMへの振る舞い指示用）
    var llmPrompt: String

    /// 参考口調（LLMの出力スタイル学習用）
    var referenceTone: String

    /// 禁止ワードリスト（LLM出力フィルタリング用）
    var prohibitedWords: [String]

    // MARK: 音声・ボイスパラメータ

    /// キャラクターボイス（CV）
    var characterVoice: String

    // MARK: トレーニング特化パラメータ

    /// 応援スタイル
    var encouragementStyle: EncouragementStyle

    /// フィードバック頻度
    var feedbackFrequency: FeedbackFrequency

    // MARK: 画像表示パラメータ

    /// ホーム画面でのキャラクター画像の拡大倍率
    var homeImageScale: CGFloat

    /// 詳細画面アイコンでのキャラクター画像の拡大倍率
    var detailIconScale: CGFloat

    /// 詳細画面アイコンでのキャラクター画像の縦方向オフセット
    var detailIconOffsetY: CGFloat

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        name: String,
        themeColor: String = "pink",
        characterImage: String,
        personalityType: PersonalityType = .cheerful,
        firstPerson: String? = nil,
        secondPerson: String? = nil,
        personalityDescription: String = "",
        llmPrompt: String? = nil,
        referenceTone: String = "",
        prohibitedWords: [String] = [],
        characterVoice: String = "ずんだもん",
        encouragementStyle: EncouragementStyle = .balanced,
        feedbackFrequency: FeedbackFrequency = .medium,
        homeImageScale: CGFloat = 2.0,
        detailIconScale: CGFloat = 2.2,
        detailIconOffsetY: CGFloat = 60
    ) {
        self.id = id
        self.name = name
        self.themeColor = themeColor
        self.characterImage = characterImage
        self.personalityType = personalityType
        self.firstPerson = firstPerson ?? personalityType.defaultFirstPerson
        self.secondPerson = secondPerson ?? personalityType.defaultSecondPerson
        self.personalityDescription = personalityDescription
        self.llmPrompt = llmPrompt ?? personalityType.defaultPrompt
        self.referenceTone = referenceTone
        self.prohibitedWords = prohibitedWords
        self.characterVoice = characterVoice
        self.encouragementStyle = encouragementStyle
        self.feedbackFrequency = feedbackFrequency
        self.homeImageScale = homeImageScale
        self.detailIconScale = detailIconScale
        self.detailIconOffsetY = detailIconOffsetY
    }
}

// MARK: - Conversion Methods

extension OshiTrainerTemplate {
    /// OshiTrainerTemplateからOshiTrainerへの変換
    /// - Parameters:
    ///   - level: レベル（デフォルト: 1）
    ///   - experience: 経験値（デフォルト: 0）
    ///   - currentDialogue: 現在のセリフ
    /// - Returns: OshiTrainerインスタンス
    func toOshiTrainer(
        level: Int = 1,
        experience: Int = 0,
        currentDialogue: String
    ) -> OshiTrainer {
        OshiTrainer(
            id: id,
            name: name,
            level: level,
            experience: experience,
            imageName: characterImage,
            currentDialogue: currentDialogue
        )
    }

    /// OshiTrainerからOshiTrainerTemplateへの変換
    /// - Parameters:
    ///   - oshiTrainer: 変換元のOshiTrainerインスタンス
    ///   - existingTemplate: 既存のテンプレート情報（nilの場合はデフォルト値を使用）
    /// - Returns: OshiTrainerTemplateインスタンス
    static func fromOshiTrainer(
        _ oshiTrainer: OshiTrainer,
        existingTemplate: OshiTrainerTemplate? = nil
    ) -> OshiTrainerTemplate {
        if let template = existingTemplate {
            // 既存テンプレートがある場合は、その情報を保持
            return OshiTrainerTemplate(
                id: oshiTrainer.id,
                name: oshiTrainer.name,
                themeColor: template.themeColor,
                characterImage: oshiTrainer.imageName,
                personalityType: template.personalityType,
                firstPerson: template.firstPerson,
                secondPerson: template.secondPerson,
                personalityDescription: template.personalityDescription,
                llmPrompt: template.llmPrompt,
                referenceTone: template.referenceTone,
                prohibitedWords: template.prohibitedWords,
                characterVoice: template.characterVoice,
                encouragementStyle: template.encouragementStyle,
                feedbackFrequency: template.feedbackFrequency,
                homeImageScale: template.homeImageScale,
                detailIconScale: template.detailIconScale,
                detailIconOffsetY: template.detailIconOffsetY
            )
        } else {
            // テンプレートがない場合はデフォルト値を使用
            let defaultPersonalityType = PersonalityType.cheerful
            return OshiTrainerTemplate(
                id: oshiTrainer.id,
                name: oshiTrainer.name,
                themeColor: "pink",
                characterImage: oshiTrainer.imageName,
                personalityType: defaultPersonalityType,
                firstPerson: defaultPersonalityType.defaultFirstPerson,
                secondPerson: defaultPersonalityType.defaultSecondPerson,
                personalityDescription: "",
                llmPrompt: defaultPersonalityType.defaultPrompt,
                referenceTone: "",
                prohibitedWords: [],
                characterVoice: "ずんだもん",
                encouragementStyle: .balanced,
                feedbackFrequency: .medium
            )
        }
    }
}
