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

        // 画像を読み込み（失敗時はフォールバック）
        if let image = UIImage(named: imageName) {
            imageView.image = image
        } else {
            print("Warning: Failed to load image '\(imageName)', using fallback")
            imageView.image = UIImage(systemName: "person.fill")
        }

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
        if let imageView = uiView.subviews.first as? AlphaHitTestImageView,
           let image = UIImage(named: imageName) {
            imageView.image = image
        }
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
