import XCTest
@testable import Oshi_Trainer

final class DialogueTemplateProviderTests: XCTestCase {

    func testGreetingDialogueIsNotEmpty() {
        // When: 挨拶カテゴリーのセリフを取得
        let dialogue = DialogueTemplateProvider.getDialogue(for: .greeting)

        // Then: 空でないセリフが返される
        XCTAssertFalse(dialogue.isEmpty)
    }

    func testTrainingStartDialogueIsNotEmpty() {
        // When: トレーニング開始カテゴリーのセリフを取得
        let dialogue = DialogueTemplateProvider.getDialogue(for: .trainingStart)

        // Then: 空でないセリフが返される
        XCTAssertFalse(dialogue.isEmpty)
    }

    func testEncouragementDialogueIsNotEmpty() {
        // When: 応援カテゴリーのセリフを取得
        let dialogue = DialogueTemplateProvider.getDialogue(for: .encouragement)

        // Then: 空でないセリフが返される
        XCTAssertFalse(dialogue.isEmpty)
    }

    func testShyReactionDialogueIsNotEmpty() {
        // When: 照れ隠しカテゴリーのセリフを取得
        let dialogue = DialogueTemplateProvider.getDialogue(for: .shyReaction)

        // Then: 空でないセリフが返される
        XCTAssertFalse(dialogue.isEmpty)
    }

    func testGreetingDialogueContainsTsundereCharacteristics() {
        // When: 挨拶カテゴリーのセリフを複数回取得（ランダム性を考慮）
        let dialogues = (0..<10).map { _ in
            DialogueTemplateProvider.getDialogue(for: .greeting)
        }

        // Then: 少なくとも1つのセリフに「うち」または「あんた」が含まれる
        let containsUchi = dialogues.contains { $0.contains("うち") }
        let containsAnta = dialogues.contains { $0.contains("あんた") }

        XCTAssertTrue(containsUchi || containsAnta, "ツンデレ性格を反映した一人称「うち」または二人称「あんた」が含まれているべき")
    }

    func testMultipleCallsReturnDifferentDialogues() {
        // When: 同じカテゴリーで複数回セリフを取得
        let dialogues = Set((0..<20).map { _ in
            DialogueTemplateProvider.getDialogue(for: .encouragement)
        })

        // Then: 複数のバリエーションが存在する（ランダム選択が機能している）
        XCTAssertGreaterThan(dialogues.count, 1, "複数のセリフバリエーションが存在するべき")
    }
}
