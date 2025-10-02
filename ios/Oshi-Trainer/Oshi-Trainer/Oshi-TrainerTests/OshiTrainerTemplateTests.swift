import XCTest
@testable import Oshi_Trainer

final class OshiTrainerTemplateTests: XCTestCase {

    // MARK: - Conversion to OshiTrainer Tests

    func testToOshiTrainerMapsPropertiesCorrectly() {
        // Given: OshiTrainerTemplate
        let template = OshiTrainerTemplate(
            name: "テストトレーナー",
            themeColor: "blue",
            characterImage: "TestImage",
            personalityType: .cheerful
        )

        // When: toOshiTrainer()を呼び出す
        let oshiTrainer = template.toOshiTrainer(
            level: 5,
            experience: 100,
            currentDialogue: "がんばって！"
        )

        // Then: プロパティが正しくマッピングされること
        XCTAssertEqual(oshiTrainer.id, template.id)
        XCTAssertEqual(oshiTrainer.name, "テストトレーナー")
        XCTAssertEqual(oshiTrainer.level, 5)
        XCTAssertEqual(oshiTrainer.experience, 100)
        XCTAssertEqual(oshiTrainer.imageName, "TestImage")
        XCTAssertEqual(oshiTrainer.currentDialogue, "がんばって！")
    }

    func testToOshiTrainerWithDefaultParameters() {
        // Given: OshiTrainerTemplate
        let template = OshiTrainerTemplate(
            name: "テストトレーナー",
            characterImage: "TestImage"
        )

        // When: デフォルトパラメータでtoOshiTrainer()を呼び出す
        let oshiTrainer = template.toOshiTrainer(currentDialogue: "こんにちは")

        // Then: デフォルト値が設定されること
        XCTAssertEqual(oshiTrainer.level, 1)
        XCTAssertEqual(oshiTrainer.experience, 0)
    }

    // MARK: - Conversion from OshiTrainer Tests

    func testFromOshiTrainerWithExistingTemplate() {
        // Given: OshiTrainerと既存のテンプレート
        let oshiTrainer = OshiTrainer(
            name: "既存トレーナー",
            level: 3,
            experience: 50,
            imageName: "ExistingImage",
            currentDialogue: "よろしく"
        )
        let existingTemplate = OshiTrainerTemplate(
            name: "元の名前",
            themeColor: "purple",
            characterImage: "OldImage",
            personalityType: .tsundere,
            characterVoice: "カスタムボイス",
            encouragementStyle: .strict,
            feedbackFrequency: .high
        )

        // When: fromOshiTrainer()を呼び出す
        let newTemplate = OshiTrainerTemplate.fromOshiTrainer(
            oshiTrainer,
            existingTemplate: existingTemplate
        )

        // Then: テンプレート情報が保持されること
        XCTAssertEqual(newTemplate.name, "既存トレーナー")
        XCTAssertEqual(newTemplate.themeColor, "purple")
        XCTAssertEqual(newTemplate.characterImage, "ExistingImage")
        XCTAssertEqual(newTemplate.personalityType, .tsundere)
        XCTAssertEqual(newTemplate.characterVoice, "カスタムボイス")
        XCTAssertEqual(newTemplate.encouragementStyle, .strict)
        XCTAssertEqual(newTemplate.feedbackFrequency, .high)
    }

    func testFromOshiTrainerWithoutExistingTemplate() {
        // Given: OshiTrainer（テンプレートなし）
        let oshiTrainer = OshiTrainer(
            name: "新規トレーナー",
            level: 1,
            experience: 0,
            imageName: "NewImage",
            currentDialogue: "よろしく"
        )

        // When: fromOshiTrainer()をテンプレートなしで呼び出す
        let template = OshiTrainerTemplate.fromOshiTrainer(oshiTrainer)

        // Then: デフォルト値が設定されること
        XCTAssertEqual(template.name, "新規トレーナー")
        XCTAssertEqual(template.themeColor, "pink")
        XCTAssertEqual(template.characterImage, "NewImage")
        XCTAssertEqual(template.personalityType, .cheerful)
        XCTAssertEqual(template.firstPerson, "私")
        XCTAssertEqual(template.secondPerson, "あなた")
        XCTAssertEqual(template.characterVoice, "ずんだもん")
        XCTAssertEqual(template.encouragementStyle, .balanced)
        XCTAssertEqual(template.feedbackFrequency, .medium)
    }

    func testFromOshiTrainerDefaultValuesMatch() {
        // Given: OshiTrainer
        let oshiTrainer = OshiTrainer(
            name: "デフォルトチェック",
            level: 1,
            experience: 0,
            imageName: "DefaultImage",
            currentDialogue: "テスト"
        )

        // When: fromOshiTrainer()をテンプレートなしで呼び出す
        let template = OshiTrainerTemplate.fromOshiTrainer(oshiTrainer)

        // Then: 要件定義通りのデフォルト値が設定されること
        XCTAssertEqual(template.themeColor, "pink")
        XCTAssertEqual(template.personalityType, .cheerful)
        XCTAssertEqual(template.firstPerson, PersonalityType.cheerful.defaultFirstPerson)
        XCTAssertEqual(template.secondPerson, PersonalityType.cheerful.defaultSecondPerson)
        XCTAssertEqual(template.characterVoice, "ずんだもん")
        XCTAssertEqual(template.encouragementStyle, .balanced)
        XCTAssertEqual(template.feedbackFrequency, .medium)
    }

    // MARK: - Initialization Tests

    func testDefaultInitializationValues() {
        // Given/When: デフォルトパラメータでOshiTrainerTemplateを作成
        let template = OshiTrainerTemplate(
            name: "デフォルトテスト",
            characterImage: "TestImage"
        )

        // Then: デフォルト値が正しく設定されること
        XCTAssertEqual(template.themeColor, "pink")
        XCTAssertEqual(template.personalityType, .cheerful)
        XCTAssertEqual(template.firstPerson, "私")
        XCTAssertEqual(template.secondPerson, "あなた")
        XCTAssertEqual(template.personalityDescription, "")
        XCTAssertFalse(template.llmPrompt.isEmpty)
        XCTAssertEqual(template.referenceTone, "")
        XCTAssertTrue(template.prohibitedWords.isEmpty)
        XCTAssertEqual(template.characterVoice, "ずんだもん")
        XCTAssertEqual(template.encouragementStyle, .balanced)
        XCTAssertEqual(template.feedbackFrequency, .medium)
    }

    func testPersonalityTypeDefaultsApplied() {
        // Given/When: ツンデレ性格でOshiTrainerTemplateを作成
        let template = OshiTrainerTemplate(
            name: "ツンデレテスト",
            characterImage: "TestImage",
            personalityType: .tsundere
        )

        // Then: 性格タイプのデフォルト値が適用されること
        XCTAssertEqual(template.firstPerson, "うち")
        XCTAssertEqual(template.secondPerson, "あんた")
        XCTAssertTrue(template.llmPrompt.contains("ツンデレ"))
    }

    func testCustomValuesOverrideDefaults() {
        // Given/When: カスタム値でOshiTrainerTemplateを作成
        let template = OshiTrainerTemplate(
            name: "カスタムテスト",
            themeColor: "blue",
            characterImage: "CustomImage",
            personalityType: .cool,
            firstPerson: "俺",
            secondPerson: "お前",
            llmPrompt: "カスタムプロンプト",
            characterVoice: "カスタムボイス",
            encouragementStyle: .strict,
            feedbackFrequency: .low
        )

        // Then: カスタム値が設定されること
        XCTAssertEqual(template.themeColor, "blue")
        XCTAssertEqual(template.personalityType, .cool)
        XCTAssertEqual(template.firstPerson, "俺")
        XCTAssertEqual(template.secondPerson, "お前")
        XCTAssertEqual(template.llmPrompt, "カスタムプロンプト")
        XCTAssertEqual(template.characterVoice, "カスタムボイス")
        XCTAssertEqual(template.encouragementStyle, .strict)
        XCTAssertEqual(template.feedbackFrequency, .low)
    }
}
