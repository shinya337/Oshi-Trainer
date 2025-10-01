import SwiftUI

struct TrainerCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var trainerName = ""
    @State private var selectedColor: Color = .oshiGreen

    var body: some View {
        ZStack {
            Color.oshiBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // タイトル
                    Text("推しトレーナーを作成")
                        .oshiTitleStyle()
                        .foregroundColor(.oshiTextPrimary)
                        .padding(.top, 32)

                    // 名前入力
                    VStack(alignment: .leading, spacing: 12) {
                        Text("トレーナー名")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.oshiTextPrimary)

                        TextField("名前を入力", text: $trainerName)
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.oshiBackgroundSecondary)
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                    }
                    .padding(.horizontal)

                    // カラー選択（プレースホルダー）
                    VStack(alignment: .leading, spacing: 12) {
                        Text("テーマカラー")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.oshiTextPrimary)

                        HStack(spacing: 16) {
                            colorButton(.green)
                            colorButton(.blue)
                            colorButton(.orange)
                            colorButton(.pink)
                            colorButton(.purple)
                        }
                    }
                    .padding(.horizontal)

                    // 外見カスタマイズ（プレースホルダー）
                    VStack(alignment: .leading, spacing: 12) {
                        Text("外見カスタマイズ")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.oshiTextPrimary)

                        VStack(spacing: 8) {
                            customizationOption("髪型", icon: "person")
                            customizationOption("服装", icon: "tshirt")
                            customizationOption("アクセサリー", icon: "star")
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    // 保存ボタン（モック）
                    Button(action: {
                        // モック：実際の保存は行わない
                        dismiss()
                    }) {
                        Text("作成する")
                            .oshiButtonLargeStyle()
                    }
                    .buttonStyle(OshiButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                    .disabled(trainerName.isEmpty)
                    .opacity(trainerName.isEmpty ? 0.5 : 1.0)
                }
            }
        }
        .navigationTitle("推しトレーナー作成")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Color Button
    private func colorButton(_ color: Color) -> some View {
        Button(action: {
            selectedColor = color
        }) {
            Circle()
                .fill(color)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .strokeBorder(
                            selectedColor == color ? Color.black : Color.clear,
                            lineWidth: 3
                        )
                )
        }
    }

    // MARK: - Customization Option
    private func customizationOption(_ title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.oshiGreen)
                .frame(width: 40)

            Text(title)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.oshiTextPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.oshiTextSecondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.oshiBackgroundSecondary)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    NavigationStack {
        TrainerCreationView()
    }
}
