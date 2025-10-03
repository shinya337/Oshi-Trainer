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
        personalityType: .tsundere,
        firstPerson: "うち",
        secondPerson: "あんた",
        personalityDescription: "ツンデレ",
        characterVoice: "VOICEVOX:ずんだもん",
        encouragementStyle: .balanced,
        feedbackFrequency: .medium,
        homeImageScale: 2.0,
        detailIconScale: 2.2,
        detailIconOffsetY: 60
    )
}
