import SwiftUI

struct CameraView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // カメラプレースホルダー背景
            Color.black
                .ignoresSafeArea()

            VStack {
                Spacer()

                // プレースホルダーテキスト
                VStack(spacing: 16) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white.opacity(0.8))

                    Text("カメラが起動されます")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("実際のカメラ機能は\n今後実装予定です")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }

                Spacer()

                // 閉じるボタン
                Button(action: {
                    dismiss()
                }) {
                    Text("完了")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(Color.oshiGreen)
                        )
                }
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    CameraView()
}
