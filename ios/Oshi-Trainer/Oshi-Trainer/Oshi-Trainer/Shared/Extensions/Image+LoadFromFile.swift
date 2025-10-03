import SwiftUI

extension Image {
    /// AssetsまたはファイルシステムからUIImageを読み込んでImageを作成
    /// - Parameter imageName: 画像名（Assetsまたはファイルシステムのファイル名）
    /// - Returns: Imageビュー
    static func loadFromAssetOrFile(_ imageName: String) -> Image {
        // まずAssetsから読み込みを試みる
        if let _ = UIImage(named: imageName) {
            return Image(imageName)
        }

        // Assetsにない場合、ファイルシステムから読み込む
        if let imagePersistence = try? ImagePersistenceService(),
           let uiImage = imagePersistence.loadImage(fileName: imageName) {
            return Image(uiImage: uiImage)
        }

        // どちらも失敗した場合、システムアイコンを返す
        print("⚠️ 画像が見つかりません: '\(imageName)', フォールバック画像を使用")
        return Image(systemName: "person.fill")
    }
}
