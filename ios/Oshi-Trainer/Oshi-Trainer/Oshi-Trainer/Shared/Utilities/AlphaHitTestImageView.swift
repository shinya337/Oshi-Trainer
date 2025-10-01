import UIKit

/// アルファチャンネルベースのヒット判定を実装したUIImageView
class AlphaHitTestImageView: UIImageView {
    /// アルファ値の閾値（この値以上であればタップを受け付ける）
    var alphaThreshold: CGFloat = 0.1

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let image = image?.cgImage else {
            // 画像がない場合は通常のヒット判定にフォールバック
            return super.point(inside: point, with: event)
        }

        // タップ座標を画像座標系に変換
        let imagePoint = convertPointToImageCoordinates(point, imageSize: CGSize(width: image.width, height: image.height))

        // 座標が画像範囲外の場合はfalse
        guard imagePoint.x >= 0 && imagePoint.x < CGFloat(image.width) &&
              imagePoint.y >= 0 && imagePoint.y < CGFloat(image.height) else {
            return false
        }

        // アルファ値を取得
        let alpha = getAlphaValue(at: imagePoint, in: image)

        // アルファ値が閾値以上であればタップを受け付ける
        return alpha >= alphaThreshold
    }

    /// タップ座標をUIImageView座標系から画像座標系に変換
    /// - Parameters:
    ///   - point: UIImageView上のタップ座標
    ///   - imageSize: 画像のサイズ
    /// - Returns: 画像座標系での座標
    private func convertPointToImageCoordinates(_ point: CGPoint, imageSize: CGSize) -> CGPoint {
        let viewSize = bounds.size

        // contentModeに応じた変換（現在はscaleAspectFillを想定）
        let scaleX = imageSize.width / viewSize.width
        let scaleY = imageSize.height / viewSize.height

        return CGPoint(
            x: point.x * scaleX,
            y: point.y * scaleY
        )
    }

    /// 指定座標のアルファ値を取得
    /// - Parameters:
    ///   - point: 画像座標系での座標
    ///   - image: CGImage
    /// - Returns: アルファ値（0.0〜1.0）、取得失敗時は1.0（不透明と仮定）
    private func getAlphaValue(at point: CGPoint, in image: CGImage) -> CGFloat {
        let width = image.width
        let height = image.height

        // ピクセルデータを格納するバッファ
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8

        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        guard let context = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            print("Warning: Failed to create CGContext for alpha testing, assuming opaque")
            return 1.0
        }

        // 画像をコンテキストに描画
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))

        // ピクセルインデックスを計算
        let pixelX = Int(point.x)
        let pixelY = Int(point.y)

        guard pixelX >= 0 && pixelX < width && pixelY >= 0 && pixelY < height else {
            return 0.0
        }

        let pixelIndex = (pixelY * width + pixelX) * bytesPerPixel

        // アルファチャンネルは4番目（RGBA）
        let alpha = CGFloat(pixelData[pixelIndex + 3]) / 255.0

        return alpha
    }
}
