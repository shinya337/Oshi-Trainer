import XCTest
@testable import Oshi_Trainer

final class TrainingParametersTests: XCTestCase {

    // MARK: - EncouragementStyle Tests

    func testStrictEncouragementStrictnessWeight() {
        // Given: 厳しめ応援スタイル
        let style = EncouragementStyle.strict

        // Then: 厳しさの重みが0.8であること
        XCTAssertEqual(style.strictnessWeight, 0.8, accuracy: 0.01)
    }

    func testGentleEncouragementStrictnessWeight() {
        // Given: 優しめ応援スタイル
        let style = EncouragementStyle.gentle

        // Then: 厳しさの重みが0.2であること
        XCTAssertEqual(style.strictnessWeight, 0.2, accuracy: 0.01)
    }

    func testBalancedEncouragementStrictnessWeight() {
        // Given: バランス型応援スタイル
        let style = EncouragementStyle.balanced

        // Then: 厳しさの重みが0.5であること
        XCTAssertEqual(style.strictnessWeight, 0.5, accuracy: 0.01)
    }

    func testEncouragementStyleAllCases() {
        // Given: EncouragementStyle列挙型
        let allCases = EncouragementStyle.allCases

        // Then: 3つのケースが存在すること
        XCTAssertEqual(allCases.count, 3)

        // Then: 全てのケースが含まれていること
        XCTAssertTrue(allCases.contains(.strict))
        XCTAssertTrue(allCases.contains(.gentle))
        XCTAssertTrue(allCases.contains(.balanced))
    }

    // MARK: - FeedbackFrequency Tests

    func testHighFeedbackFrequencyRepInterval() {
        // Given: 高頻度フィードバック
        let frequency = FeedbackFrequency.high

        // Then: レップ間隔が1であること
        XCTAssertEqual(frequency.repInterval, 1)
    }

    func testMediumFeedbackFrequencyRepInterval() {
        // Given: 中頻度フィードバック
        let frequency = FeedbackFrequency.medium

        // Then: レップ間隔が3であること
        XCTAssertEqual(frequency.repInterval, 3)
    }

    func testLowFeedbackFrequencyRepInterval() {
        // Given: 低頻度フィードバック
        let frequency = FeedbackFrequency.low

        // Then: レップ間隔が5であること
        XCTAssertEqual(frequency.repInterval, 5)
    }

    func testFeedbackFrequencyAllCases() {
        // Given: FeedbackFrequency列挙型
        let allCases = FeedbackFrequency.allCases

        // Then: 3つのケースが存在すること
        XCTAssertEqual(allCases.count, 3)

        // Then: 全てのケースが含まれていること
        XCTAssertTrue(allCases.contains(.high))
        XCTAssertTrue(allCases.contains(.medium))
        XCTAssertTrue(allCases.contains(.low))
    }
}
