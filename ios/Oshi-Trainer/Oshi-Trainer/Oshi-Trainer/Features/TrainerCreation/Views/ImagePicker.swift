import SwiftUI
import PhotosUI
import Photos

/// PHPickerViewControllerのSwiftUIラッパー
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 1
        // iCloud画像をダウンロードする設定
        configuration.preferredAssetRepresentationMode = .current

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let result = results.first else { return }

            // assetIdentifierを取得してPHAssetから直接画像を読み込む
            if let assetIdentifier = result.assetIdentifier {
                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil)

                if let asset = fetchResult.firstObject {
                    // PHAssetが取得できた場合、PHImageManagerで画像を取得
                    print("📷 PHAssetから画像を取得します")

                    let options = PHImageRequestOptions()
                    options.deliveryMode = .highQualityFormat
                    options.isNetworkAccessAllowed = true // iCloudからダウンロードを許可
                    options.isSynchronous = false

                    // 進捗ハンドラを設定
                    options.progressHandler = { progress, error, stop, info in
                        print("📥 画像ダウンロード中: \(Int(progress * 100))%")
                    }

                    let imageManager = PHImageManager.default()
                    imageManager.requestImage(
                        for: asset,
                        targetSize: PHImageManagerMaximumSize,
                        contentMode: .aspectFit,
                        options: options
                    ) { [weak self] image, info in
                        DispatchQueue.main.async {
                            if let error = info?[PHImageErrorKey] as? Error {
                                print("❌ PHImageManager画像取得エラー: \(error)")
                                // PHAssetでの取得失敗時、ItemProviderで再試行
                                print("⚠️ ItemProviderで再試行します")
                                self?.loadImageFromItemProvider(result.itemProvider)
                            } else if let uiImage = image {
                                print("✅ PHAsset経由で画像のロードに成功しました")
                                self?.parent.selectedImage = uiImage
                            } else {
                                print("❌ 画像の取得に失敗しました。ItemProviderで再試行します")
                                self?.loadImageFromItemProvider(result.itemProvider)
                            }
                        }
                    }
                } else {
                    // PHAssetの取得失敗時、ItemProviderで試行
                    print("❌ PHAssetの取得に失敗しました。ItemProviderで試行します")
                    loadImageFromItemProvider(result.itemProvider)
                }
            } else {
                // assetIdentifierがない場合（非写真ライブラリ画像）、ItemProviderで試行
                print("⚠️ assetIdentifierなし、ItemProviderで試行")
                loadImageFromItemProvider(result.itemProvider)
            }
        }

        /// ItemProviderから画像をロードする共通メソッド
        private func loadImageFromItemProvider(_ itemProvider: NSItemProvider) {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("❌ ItemProvider画像ロードエラー: \(error)")
                        } else if let uiImage = image as? UIImage {
                            print("✅ ItemProvider経由で画像のロードに成功しました")
                            self?.parent.selectedImage = uiImage
                        } else {
                            print("❌ ItemProviderからの画像取得に失敗しました")
                        }
                    }
                }
            } else {
                print("❌ ItemProviderはUIImageをサポートしていません")
            }
        }
    }
}
