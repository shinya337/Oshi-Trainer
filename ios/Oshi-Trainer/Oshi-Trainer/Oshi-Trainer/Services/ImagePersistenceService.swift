import Foundation
import UIKit

/// 画像永続化サービスのエラー型
enum ImagePersistenceError: Error {
    case directoryCreationFailed
    case imageConversionFailed
    case saveFailed
    case deleteFailed
}

/// トレーナー画像のファイルシステムへの保存と読み込みを管理するサービス
class ImagePersistenceService {
    // MARK: - Properties

    /// 画像保存ディレクトリのURL
    private let imageDirectory: URL

    // MARK: - Initialization

    init() throws {
        // Documentsディレクトリを取得
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw ImagePersistenceError.directoryCreationFailed
        }

        // TrainerImagesディレクトリのパスを作成
        imageDirectory = documentsDirectory.appendingPathComponent("TrainerImages")

        // ディレクトリが存在しない場合は作成
        if !FileManager.default.fileExists(atPath: imageDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: imageDirectory, withIntermediateDirectories: true, attributes: nil)
                print("✅ TrainerImagesディレクトリを作成しました: \(imageDirectory.path)")
            } catch {
                print("❌ TrainerImagesディレクトリ作成エラー: \(error)")
                throw ImagePersistenceError.directoryCreationFailed
            }
        }
    }

    // MARK: - Public Methods

    /// 画像を保存し、ファイル名（UUID.png）を返す
    /// - Parameter image: 保存するUIImage
    /// - Returns: 成功時はファイル名（UUID.png）、失敗時はエラー
    func saveImage(_ image: UIImage) -> Result<String, ImagePersistenceError> {
        // UIImageをPNG形式のDataに変換
        guard let imageData = image.pngData() else {
            print("❌ 画像のPNG変換に失敗しました")
            return .failure(.imageConversionFailed)
        }

        // UUIDでファイル名を生成
        let fileName = "\(UUID().uuidString).png"
        let fileURL = imageDirectory.appendingPathComponent(fileName)

        // ファイルに保存
        do {
            try imageData.write(to: fileURL)
            print("✅ 画像を保存しました: \(fileName)")
            return .success(fileName)
        } catch {
            print("❌ 画像保存エラー: \(error)")
            return .failure(.saveFailed)
        }
    }

    /// ファイル名から画像を読み込む
    /// - Parameter fileName: 画像ファイル名（UUID.png）
    /// - Returns: 読み込んだUIImage、失敗時はnil
    func loadImage(fileName: String) -> UIImage? {
        let fileURL = imageDirectory.appendingPathComponent(fileName)

        // ファイルが存在するか確認
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("⚠️ 画像ファイルが見つかりません: \(fileName)")
            return nil
        }

        // 画像を読み込み
        guard let image = UIImage(contentsOfFile: fileURL.path) else {
            print("❌ 画像読み込みエラー: \(fileName)")
            return nil
        }

        return image
    }

    /// 画像を削除
    /// - Parameter fileName: 削除する画像ファイル名（UUID.png）
    /// - Returns: 成功時は.success、失敗時はエラー
    func deleteImage(fileName: String) -> Result<Void, ImagePersistenceError> {
        let fileURL = imageDirectory.appendingPathComponent(fileName)

        // ファイルが存在するか確認
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("⚠️ 削除対象の画像ファイルが見つかりません: \(fileName)")
            return .success(()) // ファイルが存在しない場合は成功扱い
        }

        // ファイルを削除
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("✅ 画像を削除しました: \(fileName)")
            return .success(())
        } catch {
            print("❌ 画像削除エラー: \(error)")
            return .failure(.deleteFailed)
        }
    }
}
