import XCTest
@testable import Oshi_Trainer

final class DataServiceTests: XCTestCase {
    var mockService: MockDataService!
    var userDefaultsService: UserDefaultsDataService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockDataService.shared
        userDefaultsService = UserDefaultsDataService()

        // UserDefaultsをクリア
        UserDefaults.standard.removeObject(forKey: "trainerTemplates")
    }

    override func tearDownWithError() throws {
        mockService = nil
        userDefaultsService = nil

        // UserDefaultsをクリア
        UserDefaults.standard.removeObject(forKey: "trainerTemplates")

        try super.tearDownWithError()
    }

    // MARK: - MockDataService テスト

    func testMockService_GetAllTrainerTemplates_ContainsDefault() {
        // デフォルトトレーナーが含まれていることを確認
        let templates = mockService.getAllTrainerTemplates()

        XCTAssertGreaterThanOrEqual(templates.count, 1, "最低1つ（デフォルトトレーナー）が含まれるべき")
        XCTAssertTrue(templates.contains(where: { $0.name == "推乃 愛" }), "デフォルトトレーナー「推乃 愛」が含まれるべき")
    }

    func testMockService_SaveAndGetTrainerTemplate() {
        // テスト用トレーナーを作成
        let testTemplate = OshiTrainerTemplate(
            name: "テストトレーナー",
            themeColor: "blue",
            characterImage: "test.png",
            personalityType: .cheerful
        )

        // 保存
        let saveResult = mockService.saveTrainerTemplate(testTemplate)
        XCTAssertTrue(saveResult == .success(()), "保存は成功するべき")

        // 取得
        let templates = mockService.getAllTrainerTemplates()
        XCTAssertTrue(templates.contains(where: { $0.id == testTemplate.id }), "保存したトレーナーが含まれるべき")

        // ID指定で取得
        let fetchedTemplate = mockService.getTrainerTemplate(by: testTemplate.id)
        XCTAssertNotNil(fetchedTemplate, "ID指定で取得できるべき")
        XCTAssertEqual(fetchedTemplate?.name, "テストトレーナー", "名前が一致するべき")
    }

    func testMockService_UpdateTrainerTemplate() {
        // テスト用トレーナーを作成して保存
        let testTemplate = OshiTrainerTemplate(
            name: "テストトレーナー",
            themeColor: "blue",
            characterImage: "test.png",
            personalityType: .cheerful
        )
        _ = mockService.saveTrainerTemplate(testTemplate)

        // 更新
        var updatedTemplate = testTemplate
        updatedTemplate.name = "更新されたトレーナー"
        _ = mockService.saveTrainerTemplate(updatedTemplate)

        // 取得
        let fetchedTemplate = mockService.getTrainerTemplate(by: testTemplate.id)
        XCTAssertEqual(fetchedTemplate?.name, "更新されたトレーナー", "名前が更新されるべき")

        // 件数は増えないことを確認
        let templates = mockService.getAllTrainerTemplates()
        let count = templates.filter({ $0.id == testTemplate.id }).count
        XCTAssertEqual(count, 1, "同じIDのトレーナーは1つだけであるべき")
    }

    // MARK: - UserDefaultsDataService テスト

    func testUserDefaultsService_InitialState_ReturnsDefault() {
        // 初期状態ではデフォルトトレーナーのみが返される
        let templates = userDefaultsService.getAllTrainerTemplates()

        XCTAssertEqual(templates.count, 1, "初期状態ではデフォルトトレーナーのみ")
        XCTAssertEqual(templates.first?.name, "推乃 愛", "デフォルトトレーナーは「推乃 愛」")
    }

    func testUserDefaultsService_SaveAndGetTrainerTemplate() {
        // テスト用トレーナーを作成
        let testTemplate = OshiTrainerTemplate(
            name: "テストトレーナー2",
            themeColor: "green",
            characterImage: "test2.png",
            personalityType: .cool
        )

        // 保存
        let saveResult = userDefaultsService.saveTrainerTemplate(testTemplate)
        XCTAssertTrue(saveResult == .success(()), "保存は成功するべき")

        // 取得
        let templates = userDefaultsService.getAllTrainerTemplates()
        XCTAssertTrue(templates.contains(where: { $0.id == testTemplate.id }), "保存したトレーナーが含まれるべき")

        // ID指定で取得
        let fetchedTemplate = userDefaultsService.getTrainerTemplate(by: testTemplate.id)
        XCTAssertNotNil(fetchedTemplate, "ID指定で取得できるべき")
        XCTAssertEqual(fetchedTemplate?.name, "テストトレーナー2", "名前が一致するべき")
    }

    func testUserDefaultsService_PersistenceAcrossInstances() {
        // テスト用トレーナーを作成して保存
        let testTemplate = OshiTrainerTemplate(
            name: "永続化テスト",
            themeColor: "purple",
            characterImage: "persist.png",
            personalityType: .gentle
        )
        _ = userDefaultsService.saveTrainerTemplate(testTemplate)

        // 新しいインスタンスを作成
        let newService = UserDefaultsDataService()

        // 保存したトレーナーが取得できることを確認
        let fetchedTemplate = newService.getTrainerTemplate(by: testTemplate.id)
        XCTAssertNotNil(fetchedTemplate, "新しいインスタンスでも取得できるべき")
        XCTAssertEqual(fetchedTemplate?.name, "永続化テスト", "名前が一致するべき")
    }

    func testUserDefaultsService_MultipleTrainers_Order() {
        // 複数のトレーナーを保存
        let trainer1 = OshiTrainerTemplate(
            name: "トレーナー1",
            themeColor: "pink",
            characterImage: "t1.png",
            personalityType: .tsundere
        )
        let trainer2 = OshiTrainerTemplate(
            name: "トレーナー2",
            themeColor: "blue",
            characterImage: "t2.png",
            personalityType: .cheerful
        )
        let trainer3 = OshiTrainerTemplate(
            name: "トレーナー3",
            themeColor: "green",
            characterImage: "t3.png",
            personalityType: .cool
        )

        _ = userDefaultsService.saveTrainerTemplate(trainer1)
        _ = userDefaultsService.saveTrainerTemplate(trainer2)
        _ = userDefaultsService.saveTrainerTemplate(trainer3)

        // 取得
        let templates = userDefaultsService.getAllTrainerTemplates()

        // デフォルト + 3体 = 4体
        XCTAssertEqual(templates.count, 4, "4体のトレーナーが保存されるべき")

        // 順序の確認（デフォルトトレーナーが先頭）
        XCTAssertEqual(templates.first?.name, "推乃 愛", "先頭はデフォルトトレーナー")
    }
}
