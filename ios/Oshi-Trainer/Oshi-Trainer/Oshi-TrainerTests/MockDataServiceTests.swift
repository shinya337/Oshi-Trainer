import XCTest
@testable import Oshi_Trainer

final class MockDataServiceTests: XCTestCase {

    var dataService: MockDataService!

    override func setUp() {
        super.setUp()
        dataService = MockDataService.shared
    }

    func testGetOshiTrainerReturnsDefaultTrainer() {
        // When: トレーナーデータを取得
        let trainer = dataService.getOshiTrainer()

        // Then: デフォルトトレーナー「推乃 愛」のデータが返される
        XCTAssertEqual(trainer.name, "推乃 愛")
        XCTAssertEqual(trainer.level, 1)
        XCTAssertEqual(trainer.experience, 0)
        XCTAssertEqual(trainer.imageName, "OshiAi")
    }

    func testGetOshiTrainerReturnsNonEmptyDialogue() {
        // When: トレーナーデータを取得
        let trainer = dataService.getOshiTrainer()

        // Then: セリフが空でない
        XCTAssertFalse(trainer.currentDialogue.isEmpty)
    }

    func testGetOshiTrainerDialogueContainsTsundereCharacteristics() {
        // When: トレーナーデータを複数回取得（ランダムセリフ）
        let trainers = (0..<10).map { _ in
            dataService.getOshiTrainer()
        }

        // Then: 少なくとも1つのセリフに「うち」または「あんた」が含まれる
        let dialogues = trainers.map { $0.currentDialogue }
        let containsUchi = dialogues.contains { $0.contains("うち") }
        let containsAnta = dialogues.contains { $0.contains("あんた") }

        XCTAssertTrue(containsUchi || containsAnta, "ツンデレ性格を反映したセリフが含まれているべき")
    }
}
