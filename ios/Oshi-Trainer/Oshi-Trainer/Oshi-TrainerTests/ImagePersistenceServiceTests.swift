import XCTest
@testable import Oshi_Trainer

final class ImagePersistenceServiceTests: XCTestCase {
    var service: ImagePersistenceService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        service = try ImagePersistenceService()
    }

    override func tearDownWithError() throws {
        service = nil
        try super.tearDownWithError()
    }

    // MARK: - 画像保存成功テスト

    func testSaveImage_Success() throws {
        // テスト用の画像を作成（1x1ピクセルの赤い画像）
        let testImage = createTestImage(color: .red)

        // 画像を保存
        let result = service.saveImage(testImage)

        // 成功を確認
        switch result {
        case .success(let fileName):
            XCTAssertTrue(fileName.hasSuffix(".png"), "ファイル名は.pngで終わるべき")
            XCTAssertTrue(fileName.count > 10, "ファイル名はUUID形式であるべき")

            // 保存された画像を読み込んで確認
            let loadedImage = service.loadImage(fileName: fileName)
            XCTAssertNotNil(loadedImage, "保存した画像を読み込めるべき")

            // クリーンアップ
            _ = service.deleteImage(fileName: fileName)

        case .failure(let error):
            XCTFail("画像保存が失敗しました: \(error)")
        }
    }

    // MARK: - 画像読み込み成功テスト

    func testLoadImage_Success() throws {
        // テスト用の画像を保存
        let testImage = createTestImage(color: .blue)
        let result = service.saveImage(testImage)

        guard case .success(let fileName) = result else {
            XCTFail("画像保存が失敗しました")
            return
        }

        // 画像を読み込み
        let loadedImage = service.loadImage(fileName: fileName)

        // 読み込み成功を確認
        XCTAssertNotNil(loadedImage, "画像を読み込めるべき")

        // クリーンアップ
        _ = service.deleteImage(fileName: fileName)
    }

    // MARK: - 画像読み込み失敗テスト（存在しないファイル）

    func testLoadImage_FileNotFound() {
        // 存在しないファイル名で読み込み
        let loadedImage = service.loadImage(fileName: "nonexistent.png")

        // nilが返されることを確認
        XCTAssertNil(loadedImage, "存在しないファイルはnilを返すべき")
    }

    // MARK: - 画像削除成功テスト

    func testDeleteImage_Success() throws {
        // テスト用の画像を保存
        let testImage = createTestImage(color: .green)
        let result = service.saveImage(testImage)

        guard case .success(let fileName) = result else {
            XCTFail("画像保存が失敗しました")
            return
        }

        // 画像を削除
        let deleteResult = service.deleteImage(fileName: fileName)

        // 削除成功を確認
        switch deleteResult {
        case .success:
            // 削除後に読み込みを試み、nilが返されることを確認
            let loadedImage = service.loadImage(fileName: fileName)
            XCTAssertNil(loadedImage, "削除後は画像を読み込めないべき")

        case .failure(let error):
            XCTFail("画像削除が失敗しました: \(error)")
        }
    }

    // MARK: - 画像削除テスト（存在しないファイル）

    func testDeleteImage_FileNotFound() {
        // 存在しないファイルを削除
        let deleteResult = service.deleteImage(fileName: "nonexistent.png")

        // 成功扱いになることを確認（冪等性）
        switch deleteResult {
        case .success:
            XCTAssert(true, "存在しないファイルの削除は成功扱いになるべき")
        case .failure:
            XCTFail("存在しないファイルの削除は成功扱いになるべき")
        }
    }

    // MARK: - 複数画像の保存・読み込みテスト

    func testMultipleImages_SaveAndLoad() throws {
        var fileNames: [String] = []

        // 3つの画像を保存
        for color in [UIColor.red, UIColor.blue, UIColor.green] {
            let testImage = createTestImage(color: color)
            let result = service.saveImage(testImage)

            guard case .success(let fileName) = result else {
                XCTFail("画像保存が失敗しました")
                return
            }

            fileNames.append(fileName)
        }

        // 3つの画像がすべて読み込めることを確認
        for fileName in fileNames {
            let loadedImage = service.loadImage(fileName: fileName)
            XCTAssertNotNil(loadedImage, "保存した画像を読み込めるべき")
        }

        // クリーンアップ
        for fileName in fileNames {
            _ = service.deleteImage(fileName: fileName)
        }
    }

    // MARK: - ヘルパーメソッド

    /// テスト用の画像を作成
    private func createTestImage(color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
