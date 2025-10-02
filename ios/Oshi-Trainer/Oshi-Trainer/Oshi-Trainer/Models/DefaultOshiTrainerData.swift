import Foundation

/// デフォルト推しトレーナー「推乃 愛（オシノ アイ）」のデータ定義
struct DefaultOshiTrainerData {
    /// デフォルトトレーナー「推乃 愛」
    static let oshiAi = OshiTrainer(
        name: "推乃 愛",
        level: 1,
        experience: 0,
        imageName: "Oshino-Ai",
        currentDialogue: ""
    )

    /// デフォルトトレーナー「推乃 愛」のテンプレート
    static let oshiAiTemplate = OshiTrainerTemplate(
        id: oshiAi.id,
        name: "推乃 愛",
        themeColor: "pink",
        characterImage: "Oshino-Ai",
        personalityType: .cheerful,
        firstPerson: "私",
        secondPerson: "あなた",
        personalityDescription: "明るく元気な性格で、いつもポジティブに応援してくれます",
        characterVoice: "ずんだもん",
        encouragementStyle: .balanced,
        feedbackFrequency: .medium
    )
}
