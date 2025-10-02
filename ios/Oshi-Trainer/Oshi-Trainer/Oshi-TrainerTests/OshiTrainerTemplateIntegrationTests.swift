import XCTest
@testable import Oshi_Trainer

final class OshiTrainerTemplateIntegrationTests: XCTestCase {

    // MARK: - Template to OshiTrainer Conversion Flow Tests

    func testTemplateToOshiTrainerConversionFlow() {
        // Given: OshiTrainerTemplateを作成
        let template = OshiTrainerTemplate(
            name: "統合テストトレーナー",
            themeColor: "blue",
            characterImage: "IntegrationTestImage",
            personalityType: .cheerful,
            firstPerson: "私",
            secondPerson: "あなた",
            personalityDescription: "明るく元気な性格です",
            characterVoice: "ずんだもん",
            encouragementStyle: .balanced,
            feedbackFrequency: .medium
        )

        // When: toOshiTrainer()でOshiTrainerに変換
        let oshiTrainer = template.toOshiTrainer(
            level: 3,
            experience: 75,
            currentDialogue: "今日もがんばろう！"
        )

        // Then: プロパティが正しくマッピングされること
        XCTAssertEqual(oshiTrainer.id, template.id)
        XCTAssertEqual(oshiTrainer.name, "統合テストトレーナー")
        XCTAssertEqual(oshiTrainer.level, 3)
        XCTAssertEqual(oshiTrainer.experience, 75)
        XCTAssertEqual(oshiTrainer.imageName, "IntegrationTestImage")
        XCTAssertEqual(oshiTrainer.currentDialogue, "今日もがんばろう！")
    }

    func testOshiTrainerToTemplateDefaultsConversionFlow() {
        // Given: OshiTrainerを作成（テンプレートなし）
        let oshiTrainer = OshiTrainer(
            name: "既存トレーナー",
            level: 5,
            experience: 200,
            imageName: "ExistingImage",
            currentDialogue: "がんばって！"
        )

        // When: fromOshiTrainer()でテンプレートに変換（テンプレートなし）
        let template = OshiTrainerTemplate.fromOshiTrainer(oshiTrainer)

        // Then: デフォルト値が正しく設定されること
        XCTAssertEqual(template.id, oshiTrainer.id)
        XCTAssertEqual(template.name, "既存トレーナー")
        XCTAssertEqual(template.themeColor, "pink")
        XCTAssertEqual(template.characterImage, "ExistingImage")
        XCTAssertEqual(template.personalityType, .cheerful)
        XCTAssertEqual(template.firstPerson, "私")
        XCTAssertEqual(template.secondPerson, "あなた")
        XCTAssertEqual(template.characterVoice, "ずんだもん")
        XCTAssertEqual(template.encouragementStyle, .balanced)
        XCTAssertEqual(template.feedbackFrequency, .medium)
    }

    func testBidirectionalConversionConsistency() {
        // Given: 元のOshiTrainerTemplateを作成
        let originalTemplate = OshiTrainerTemplate(
            name: "双方向テスト",
            themeColor: "purple",
            characterImage: "BidirectionalImage",
            personalityType: .tsundere,
            firstPerson: "うち",
            secondPerson: "あんた",
            personalityDescription: "ツンデレな性格",
            characterVoice: "カスタムボイス",
            encouragementStyle: .strict,
            feedbackFrequency: .high
        )

        // When: Template -> OshiTrainer -> Template と変換
        let oshiTrainer = originalTemplate.toOshiTrainer(
            level: 10,
            experience: 500,
            currentDialogue: "別に心配してるわけじゃないんだからね！"
        )
        let convertedTemplate = OshiTrainerTemplate.fromOshiTrainer(
            oshiTrainer,
            existingTemplate: originalTemplate
        )

        // Then: テンプレート情報が保持されること
        XCTAssertEqual(convertedTemplate.name, oshiTrainer.name)
        XCTAssertEqual(convertedTemplate.themeColor, originalTemplate.themeColor)
        XCTAssertEqual(convertedTemplate.personalityType, originalTemplate.personalityType)
        XCTAssertEqual(convertedTemplate.firstPerson, originalTemplate.firstPerson)
        XCTAssertEqual(convertedTemplate.secondPerson, originalTemplate.secondPerson)
        XCTAssertEqual(convertedTemplate.characterVoice, originalTemplate.characterVoice)
        XCTAssertEqual(convertedTemplate.encouragementStyle, originalTemplate.encouragementStyle)
        XCTAssertEqual(convertedTemplate.feedbackFrequency, originalTemplate.feedbackFrequency)
    }

    // MARK: - PersonalityType and Default Values Integration Tests

    func testTsunderePersonalityDefaults() {
        // Given/When: ツンデレ性格でテンプレートを作成
        let template = OshiTrainerTemplate(
            name: "ツンデレトレーナー",
            characterImage: "TsundereImage",
            personalityType: .tsundere
        )

        // Then: 一人称「うち」、二人称「あんた」が設定されること
        XCTAssertEqual(template.firstPerson, "うち")
        XCTAssertEqual(template.secondPerson, "あんた")
        XCTAssertTrue(template.llmPrompt.contains("ツンデレ"))
    }

    func testCheerfulPersonalityDefaults() {
        // Given/When: 元気性格でテンプレートを作成
        let template = OshiTrainerTemplate(
            name: "元気トレーナー",
            characterImage: "CheerfulImage",
            personalityType: .cheerful
        )

        // Then: 一人称「私」、二人称「あなた」が設定されること
        XCTAssertEqual(template.firstPerson, "私")
        XCTAssertEqual(template.secondPerson, "あなた")
        XCTAssertTrue(template.llmPrompt.contains("元気"))
    }

    func testGentlePersonalityDefaults() {
        // Given/When: 優しい性格でテンプレートを作成
        let template = OshiTrainerTemplate(
            name: "優しいトレーナー",
            characterImage: "GentleImage",
            personalityType: .gentle
        )

        // Then: 一人称「私」、二人称「あなた」が設定されること
        XCTAssertEqual(template.firstPerson, "私")
        XCTAssertEqual(template.secondPerson, "あなた")
        XCTAssertTrue(template.llmPrompt.contains("優しく"))
    }

    func testCoolPersonalityDefaults() {
        // Given/When: クール性格でテンプレートを作成
        let template = OshiTrainerTemplate(
            name: "クールトレーナー",
            characterImage: "CoolImage",
            personalityType: .cool
        )

        // Then: 一人称「僕」、二人称「君」が設定されること
        XCTAssertEqual(template.firstPerson, "僕")
        XCTAssertEqual(template.secondPerson, "君")
        XCTAssertTrue(template.llmPrompt.contains("クール"))
    }

    func testPersonalityTypeChangeUpdatesDefaults() {
        // Given: 初期の性格タイプでテンプレートを作成
        var template = OshiTrainerTemplate(
            name: "変更テスト",
            characterImage: "TestImage",
            personalityType: .cheerful
        )

        // 初期状態を確認
        XCTAssertEqual(template.firstPerson, "私")
        XCTAssertEqual(template.secondPerson, "あなた")

        // When: 性格タイプを変更して新しいテンプレートを作成
        template = OshiTrainerTemplate(
            name: template.name,
            characterImage: template.characterImage,
            personalityType: .tsundere
        )

        // Then: デフォルト値が自動更新されること
        XCTAssertEqual(template.firstPerson, "うち")
        XCTAssertEqual(template.secondPerson, "あんた")
    }

    // MARK: - Complete Workflow Test

    func testCompleteOshiTrainerCreationWorkflow() {
        // Given: 新しい推しトレーナーを作成するワークフロー

        // Step 1: OshiTrainerTemplateを作成（ユーザーが推し作成フォームに入力）
        let template = OshiTrainerTemplate(
            name: "推乃 愛",
            themeColor: "pink",
            characterImage: "OshiAi",
            personalityType: .cheerful,
            personalityDescription: "明るく元気な性格で、いつもポジティブに応援してくれます",
            characterVoice: "ずんだもん",
            encouragementStyle: .balanced,
            feedbackFrequency: .medium
        )

        // Step 2: テンプレートからOshiTrainerを生成（アプリ内で実行時データを作成）
        let oshiTrainer = template.toOshiTrainer(
            level: 1,
            experience: 0,
            currentDialogue: "一緒にがんばろうね！"
        )

        // Step 3: 検証
        XCTAssertEqual(oshiTrainer.name, "推乃 愛")
        XCTAssertEqual(oshiTrainer.level, 1)
        XCTAssertEqual(oshiTrainer.experience, 0)
        XCTAssertEqual(oshiTrainer.imageName, "OshiAi")
        XCTAssertEqual(oshiTrainer.currentDialogue, "一緒にがんばろうね！")

        // Step 4: 既存のOshiTrainerから編集のためテンプレートを復元
        let restoredTemplate = OshiTrainerTemplate.fromOshiTrainer(
            oshiTrainer,
            existingTemplate: template
        )

        // Step 5: テンプレート情報が保持されていることを確認
        XCTAssertEqual(restoredTemplate.themeColor, "pink")
        XCTAssertEqual(restoredTemplate.personalityType, .cheerful)
        XCTAssertEqual(restoredTemplate.characterVoice, "ずんだもん")
        XCTAssertEqual(restoredTemplate.encouragementStyle, .balanced)
        XCTAssertEqual(restoredTemplate.feedbackFrequency, .medium)
    }
}
