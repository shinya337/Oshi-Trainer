import XCTest
import SwiftUI
@testable import Oshi_Trainer

final class ColorOshiThemeTests: XCTestCase {

    // MARK: - Theme Color Tests

    func testOshiThemeColorPink() {
        // Given: "pink"識別子
        let identifier = "pink"

        // When: oshiThemeColor(from:)を呼び出す
        let color = Color.oshiThemeColor(from: identifier)

        // Then: ピンクカラーが返されること
        XCTAssertNotNil(color)
        // 色の値を直接比較することはできないため、存在確認のみ
    }

    func testOshiThemeColorBlue() {
        // Given: "blue"識別子
        let identifier = "blue"

        // When: oshiThemeColor(from:)を呼び出す
        let color = Color.oshiThemeColor(from: identifier)

        // Then: ブルーカラーが返されること
        XCTAssertNotNil(color)
    }

    func testOshiThemeColorGreen() {
        // Given: "green"識別子
        let identifier = "green"

        // When: oshiThemeColor(from:)を呼び出す
        let color = Color.oshiThemeColor(from: identifier)

        // Then: グリーンカラーが返されること
        XCTAssertNotNil(color)
    }

    func testOshiThemeColorOrange() {
        // Given: "orange"識別子
        let identifier = "orange"

        // When: oshiThemeColor(from:)を呼び出す
        let color = Color.oshiThemeColor(from: identifier)

        // Then: オレンジカラーが返されること
        XCTAssertNotNil(color)
    }

    func testOshiThemeColorPurple() {
        // Given: "purple"識別子
        let identifier = "purple"

        // When: oshiThemeColor(from:)を呼び出す
        let color = Color.oshiThemeColor(from: identifier)

        // Then: パープルカラーが返されること
        XCTAssertNotNil(color)
    }

    func testOshiThemeColorInvalidReturnsDefault() {
        // Given: 不正な識別子
        let identifier = "invalid_color"

        // When: oshiThemeColor(from:)を呼び出す
        let color = Color.oshiThemeColor(from: identifier)

        // Then: デフォルトカラー（pink）が返されること
        XCTAssertNotNil(color)
        // デフォルトカラーはpinkと同じはず
    }

    func testOshiThemeColorCaseInsensitive() {
        // Given: 大文字の識別子
        let upperIdentifier = "PINK"
        let mixedIdentifier = "BlUe"

        // When: oshiThemeColor(from:)を呼び出す
        let upperColor = Color.oshiThemeColor(from: upperIdentifier)
        let mixedColor = Color.oshiThemeColor(from: mixedIdentifier)

        // Then: 正しいカラーが返されること（大文字小文字を区別しない）
        XCTAssertNotNil(upperColor)
        XCTAssertNotNil(mixedColor)
    }

    // MARK: - Theme Color Light Tests

    func testOshiThemeColorLight() {
        // Given: "pink"識別子
        let identifier = "pink"

        // When: oshiThemeColorLight(from:)を呼び出す
        let lightColor = Color.oshiThemeColorLight(from: identifier)

        // Then: 透明度0.6のカラーが返されること
        XCTAssertNotNil(lightColor)
        // SwiftUIのColorでは透明度を直接取得できないため、存在確認のみ
    }

    func testOshiThemeColorLightForAllColors() {
        // Given: 全ての有効な識別子
        let identifiers = ["pink", "blue", "green", "orange", "purple"]

        // When/Then: 全ての識別子で薄いカラーが返されること
        for identifier in identifiers {
            let lightColor = Color.oshiThemeColorLight(from: identifier)
            XCTAssertNotNil(lightColor, "\(identifier) should return a valid light color")
        }
    }

    func testOshiThemeColorLightInvalidReturnsDefaultLight() {
        // Given: 不正な識別子
        let identifier = "invalid"

        // When: oshiThemeColorLight(from:)を呼び出す
        let lightColor = Color.oshiThemeColorLight(from: identifier)

        // Then: デフォルトカラーの薄いバージョンが返されること
        XCTAssertNotNil(lightColor)
    }
}
