import XCTest
@testable import Oshi_Trainer

final class PersonalityTypeTests: XCTestCase {

    // MARK: - Default First Person Tests

    func testTsundereDefaultFirstPerson() {
        // Given: ツンデレ性格タイプ
        let personality = PersonalityType.tsundere

        // Then: デフォルト一人称が「うち」であること
        XCTAssertEqual(personality.defaultFirstPerson, "うち")
    }

    func testCheerfulDefaultFirstPerson() {
        // Given: 元気性格タイプ
        let personality = PersonalityType.cheerful

        // Then: デフォルト一人称が「私」であること
        XCTAssertEqual(personality.defaultFirstPerson, "私")
    }

    func testGentleDefaultFirstPerson() {
        // Given: 優しい性格タイプ
        let personality = PersonalityType.gentle

        // Then: デフォルト一人称が「私」であること
        XCTAssertEqual(personality.defaultFirstPerson, "私")
    }

    func testCoolDefaultFirstPerson() {
        // Given: クール性格タイプ
        let personality = PersonalityType.cool

        // Then: デフォルト一人称が「僕」であること
        XCTAssertEqual(personality.defaultFirstPerson, "僕")
    }

    // MARK: - Default Second Person Tests

    func testTsundereDefaultSecondPerson() {
        // Given: ツンデレ性格タイプ
        let personality = PersonalityType.tsundere

        // Then: デフォルト二人称が「あんた」であること
        XCTAssertEqual(personality.defaultSecondPerson, "あんた")
    }

    func testCheerfulDefaultSecondPerson() {
        // Given: 元気性格タイプ
        let personality = PersonalityType.cheerful

        // Then: デフォルト二人称が「あなた」であること
        XCTAssertEqual(personality.defaultSecondPerson, "あなた")
    }

    func testGentleDefaultSecondPerson() {
        // Given: 優しい性格タイプ
        let personality = PersonalityType.gentle

        // Then: デフォルト二人称が「あなた」であること
        XCTAssertEqual(personality.defaultSecondPerson, "あなた")
    }

    func testCoolDefaultSecondPerson() {
        // Given: クール性格タイプ
        let personality = PersonalityType.cool

        // Then: デフォルト二人称が「君」であること
        XCTAssertEqual(personality.defaultSecondPerson, "君")
    }

    // MARK: - Default Prompt Tests

    func testAllPersonalityTypesHaveNonEmptyDefaultPrompt() {
        // Given: 全ての性格タイプ
        let allTypes = PersonalityType.allCases

        // Then: 全てのデフォルトプロンプトが空でないこと
        for personality in allTypes {
            XCTAssertFalse(
                personality.defaultPrompt.isEmpty,
                "\(personality.rawValue) should have a non-empty default prompt"
            )
        }
    }

    // MARK: - CaseIterable Tests

    func testAllCasesAreIterable() {
        // Given: PersonalityType列挙型
        let allCases = PersonalityType.allCases

        // Then: 4つのケースが存在すること
        XCTAssertEqual(allCases.count, 4)

        // Then: 全てのケースが含まれていること
        XCTAssertTrue(allCases.contains(.tsundere))
        XCTAssertTrue(allCases.contains(.cheerful))
        XCTAssertTrue(allCases.contains(.gentle))
        XCTAssertTrue(allCases.contains(.cool))
    }
}
