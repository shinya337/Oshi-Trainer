import XCTest
@testable import Oshi_Trainer

final class DefaultOshiTrainerDataTests: XCTestCase {

    func testDefaultTrainerHasCorrectName() {
        // Given: デフォルトトレーナー「推乃 愛」
        let trainer = DefaultOshiTrainerData.oshiAi

        // Then: 名前が「推乃 愛」であること
        XCTAssertEqual(trainer.name, "推乃 愛")
    }

    func testDefaultTrainerHasLevelOne() {
        // Given: デフォルトトレーナー
        let trainer = DefaultOshiTrainerData.oshiAi

        // Then: レベルが1であること
        XCTAssertEqual(trainer.level, 1)
    }

    func testDefaultTrainerHasZeroExperience() {
        // Given: デフォルトトレーナー
        let trainer = DefaultOshiTrainerData.oshiAi

        // Then: 経験値が0であること
        XCTAssertEqual(trainer.experience, 0)
    }

    func testDefaultTrainerHasCorrectImageName() {
        // Given: デフォルトトレーナー
        let trainer = DefaultOshiTrainerData.oshiAi

        // Then: 画像名が"OshiAi"であること
        XCTAssertEqual(trainer.imageName, "OshiAi")
    }
}
