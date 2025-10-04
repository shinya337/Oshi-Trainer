import Foundation
import Intents
import UIKit

/// OshiTrainerTemplateからINPersonオブジェクトを生成するユーティリティ
class INPersonBuilder {
    /// App Group ID
    private static let appGroupId = "group.com.yourcompany.VirtualTrainer"

    /// App Group共有コンテナのURL
    private static var appGroupContainer: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
    }

    /// トレーナーテンプレートからINPersonを作成
    /// - Parameters:
    ///   - template: トレーナーテンプレート
    ///   - iconScale: 通知アイコンの拡大倍率（デフォルト: 1.0）
    ///   - iconOffset: 画像の縦方向オフセット（デフォルト: 0.0、正の値で下に、負の値で上に）
    /// - Returns: INPersonオブジェクト
    static func createPerson(
        from template: OshiTrainerTemplate,
        iconScale: CGFloat = 1.0,
        iconOffset: CGFloat = 0.0
    ) -> INPerson {
        // トレーナー名を displayName に設定
        let displayName = template.name

        // トレーナーIDを personHandle に設定
        let personHandle = INPersonHandle(value: template.id.uuidString, type: .unknown)

        // 画像を取得（スケールとオフセットを適用）
        let image = loadImage(fileName: template.characterImage, scale: iconScale, offsetY: iconOffset)

        // INPersonを作成
        let person = INPerson(
            personHandle: personHandle,
            nameComponents: nil,
            displayName: displayName,
            image: image,
            contactIdentifier: nil,
            customIdentifier: template.id.uuidString
        )

        return person
    }

    /// 画像ファイル名からINImageを作成
    /// - Parameters:
    ///   - fileName: 画像ファイル名（UUID.pngまたは拡張子なし）
    ///   - scale: 拡大倍率（1.0 = 等倍、1.5 = 1.5倍、0.8 = 0.8倍）
    ///   - offsetY: 縦方向オフセット（ピクセル単位、正の値で下に移動）
    /// - Returns: INImage、失敗時はnil
    private static func loadImage(fileName: String, scale: CGFloat = 1.0, offsetY: CGFloat = 0.0) -> INImage? {
        // App Group共有ディレクトリから画像パスを構築
        guard let appGroupURL = appGroupContainer else {
            print("⚠️ App Groupコンテナが利用できません")
            return nil
        }

        // ファイル名に.pngを追加（拡張子がない場合）
        let imageFileName = fileName.hasSuffix(".png") ? fileName : "\(fileName).png"

        let imagePath = appGroupURL
            .appendingPathComponent("TrainerImages")
            .appendingPathComponent(imageFileName)

        // ファイルが存在するか確認
        guard FileManager.default.fileExists(atPath: imagePath.path) else {
            print("⚠️ 画像ファイルが見つかりません: \(imageFileName)")
            return nil
        }

        // UIImageから読み込み
        guard var uiImage = UIImage(contentsOfFile: imagePath.path) else {
            print("❌ 画像読み込みエラー: \(fileName)")
            return nil
        }

        // スケールまたはオフセットが指定されている場合は画像を加工
        print("📊 画像加工パラメータ: scale=\(scale), offsetY=\(offsetY)")
        if scale != 1.0 || offsetY != 0.0 {
            print("✅ 画像加工を実行します")
            uiImage = processImage(uiImage, scale: scale, offsetY: offsetY)
        } else {
            print("ℹ️ 画像加工はスキップされました（デフォルト値）")
        }

        // INImageを作成
        guard let imageData = uiImage.pngData() else {
            print("❌ 画像データ変換エラー: \(fileName)")
            return nil
        }

        let inImage = INImage(imageData: imageData)
        return inImage
    }

    /// 画像にスケールとオフセットを適用
    private static func processImage(_ image: UIImage, scale: CGFloat, offsetY: CGFloat) -> UIImage {
        let size = CGSize(width: 200, height: 200) // 通知アイコン用の固定サイズ
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            // 円形にクロップ
            let circlePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
            circlePath.addClip()

            // 元画像のアスペクト比
            let aspectRatio = image.size.width / image.size.height

            // スケールを適用したサイズを計算
            var drawWidth: CGFloat
            var drawHeight: CGFloat

            if aspectRatio > 1 {
                // 横長画像 - 高さを基準にスケール
                drawHeight = size.height * scale
                drawWidth = drawHeight * aspectRatio
            } else {
                // 縦長・正方形画像 - 幅を基準にスケール
                drawWidth = size.width * scale
                drawHeight = drawWidth / aspectRatio
            }

            // 中央配置 + オフセット適用
            let drawRect = CGRect(
                x: (size.width - drawWidth) / 2,
                y: (size.height - drawHeight) / 2 + offsetY,
                width: drawWidth,
                height: drawHeight
            )

            print("🎨 画像加工: scale=\(scale), offsetY=\(offsetY)")
            print("📐 元画像サイズ: \(image.size)")
            print("📐 描画サイズ: \(drawRect.size)")

            // 画像を描画
            image.draw(in: drawRect)
        }
    }
}
