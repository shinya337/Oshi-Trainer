import SwiftUI
import UIKit

/// 背景透過画像の不透明部分のみをタップ可能にするカスタムImageView
struct TransparentImageView: UIViewRepresentable {
    let imageName: String
    let onTap: () -> Void

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()

        let imageView = AlphaHitTestImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true

        // 画像を読み込み（Assetsまたはファイルシステム）
        imageView.image = loadImage(named: imageName)

        // タップジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        imageView.addGestureRecognizer(tapGesture)

        containerView.addSubview(imageView)

        // Auto Layoutで中央に配置
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // 画像名が変更された場合に画像を更新
        if let imageView = uiView.subviews.first as? AlphaHitTestImageView {
            imageView.image = loadImage(named: imageName)
        }
    }

    /// 画像を読み込む（Assetsまたはファイルシステム）
    private func loadImage(named imageName: String) -> UIImage {
        // まずAssetsから読み込みを試みる
        if let image = UIImage(named: imageName) {
            return image
        }

        // Assetsにない場合、ファイルシステムから読み込む（UUID.png形式）
        if let imagePersistence = try? ImagePersistenceService(),
           let image = imagePersistence.loadImage(fileName: imageName) {
            return image
        }

        // どちらも失敗した場合、フォールバック画像を返す
        print("⚠️ 画像が見つかりません: '\(imageName)', フォールバック画像を使用")
        return UIImage(systemName: "person.fill") ?? UIImage()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onTap: onTap)
    }

    class Coordinator: NSObject {
        let onTap: () -> Void

        init(onTap: @escaping () -> Void) {
            self.onTap = onTap
        }

        @objc func handleTap() {
            onTap()
        }
    }
}
