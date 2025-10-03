import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct TrainerCreationView: View {
    @StateObject private var viewModel = TrainerCreationViewModel()
    @Environment(\.dismiss) private var dismiss

    // 入力状態
    @State private var name: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var themeColor: String = "pink"
    @State private var personalityType: PersonalityType = .cheerful
    @State private var firstPerson: String = ""
    @State private var secondPerson: String = ""
    @State private var characterVoice: String = "ずんだもん"

    // UI状態
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showImagePicker = false

    var body: some View {
        ZStack {
            Color.oshiBackground
                .ignoresSafeArea()
                .onTapGesture {
                    // キーボードを閉じる
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }

            ScrollView {
                VStack(spacing: 24) {
                    // タイトル
                    Text("推しトレーナー作成")
                        .oshiTitleStyle()
                        .foregroundColor(.oshiPink)
                        .padding(.top, 32)

                    // キャラクター画像選択
                    VStack(alignment: .leading, spacing: 12) {
                        Text("キャラクター画像")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.oshiTextPrimary)

                        Button(action: {
                            showImagePicker = true
                        }) {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                VStack(spacing: 12) {
                                    Image(systemName: "photo.badge.plus")
                                        .font(.system(size: 48))
                                        .foregroundColor(.oshiTextSecondary)
                                    Text("画像を選択")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(.oshiTextSecondary)
                                }
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.oshiBackgroundSecondary)
                                )
                            }
                        }

                        if selectedImage == nil {
                            Text("画像を選択してください")
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)

                    // 名前入力
                    VStack(alignment: .leading, spacing: 12) {
                        Text("名前")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.oshiTextPrimary)

                        ZStack(alignment: .leading) {
                            if name.isEmpty {
                                Text("名前を入力")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                    .foregroundColor(.oshiTextSecondary)
                                    .padding(.leading, 16)
                            }
                            TextField("", text: $name)
                                .font(.system(size: 18, weight: .regular, design: .rounded))
                                .foregroundColor(.oshiTextPrimary)
                                .padding()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.oshiBackgroundSecondary)
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        )

                        if !name.isEmpty && name.count > 30 {
                            Text("名前は30文字以内にしてください（現在: \(name.count)文字）")
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(.red)
                        } else if name.isEmpty {
                            Text("名前を入力してください")
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)

                    // イメージカラー選択
                    VStack(alignment: .leading, spacing: 12) {
                        Text("イメージカラー")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.oshiTextPrimary)

                        HStack(spacing: 16) {
                            colorButton("pink", Color.oshiThemeColor(from: "pink"))
                            colorButton("blue", Color.oshiThemeColor(from: "blue"))
                            colorButton("green", Color.oshiThemeColor(from: "green"))
                            colorButton("orange", Color.oshiThemeColor(from: "orange"))
                            colorButton("purple", Color.oshiThemeColor(from: "purple"))
                        }
                    }
                    .padding(.horizontal)

                    // 一人称・呼び方
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("一人称")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.oshiTextPrimary)

                            ZStack(alignment: .leading) {
                                if firstPerson.isEmpty {
                                    Text("例: 私")
                                        .font(.system(size: 18, weight: .regular, design: .rounded))
                                        .foregroundColor(.oshiTextSecondary)
                                        .padding(.leading, 16)
                                }
                                TextField("", text: $firstPerson)
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                    .foregroundColor(.oshiTextPrimary)
                                    .padding()
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.oshiBackgroundSecondary)
                            )
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("呼び方")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.oshiTextPrimary)

                            ZStack(alignment: .leading) {
                                if secondPerson.isEmpty {
                                    Text("例: あなた")
                                        .font(.system(size: 18, weight: .regular, design: .rounded))
                                        .foregroundColor(.oshiTextSecondary)
                                        .padding(.leading, 16)
                                }
                                TextField("", text: $secondPerson)
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                    .foregroundColor(.oshiTextPrimary)
                                    .padding()
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.oshiBackgroundSecondary)
                            )
                        }
                    }
                    .padding(.horizontal)

                    // 性格選択
                    VStack(alignment: .leading, spacing: 12) {
                        Text("性格")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.oshiTextPrimary)

                        Picker("性格", selection: $personalityType) {
                            ForEach(PersonalityType.allCases, id: \.self) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal)

                    // ボイス選択
                    VStack(alignment: .leading, spacing: 12) {
                        Text("ボイス")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.oshiTextPrimary)

                        VStack(spacing: 8) {
                            voiceOption("ずんだもん")
                            voiceOption("四国めたん")
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    // エラーメッセージ
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    // 作成ボタン
                    Button(action: {
                        Task {
                            guard let image = selectedImage else {
                                alertMessage = "画像を選択してください"
                                showAlert = true
                                return
                            }

                            let result = await viewModel.createTrainer(
                                name: name,
                                image: image,
                                themeColor: themeColor,
                                personalityType: personalityType,
                                firstPerson: firstPerson.isEmpty ? nil : firstPerson,
                                secondPerson: secondPerson.isEmpty ? nil : secondPerson,
                                characterVoice: characterVoice
                            )

                            if case .success = result {
                                dismiss()
                            }
                        }
                    }) {
                        if viewModel.isCreating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("作成する")
                                .oshiButtonLargeStyle()
                        }
                    }
                    .buttonStyle(OshiButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                    .disabled(name.isEmpty || selectedImage == nil || viewModel.isCreating)
                    .opacity((name.isEmpty || selectedImage == nil || viewModel.isCreating) ? 0.5 : 1.0)
                }
            }
            .simultaneousGesture(
                TapGesture().onEnded { _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            )
        }
        .navigationTitle("推しトレーナー作成")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .alert("エラー", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - Color Button
    private func colorButton(_ colorId: String, _ color: Color) -> some View {
        Button(action: {
            themeColor = colorId
        }) {
            Circle()
                .fill(color)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .strokeBorder(
                            themeColor == colorId ? Color.black : Color.clear,
                            lineWidth: 3
                        )
                )
        }
    }

    // MARK: - Voice Option
    private func voiceOption(_ voiceName: String) -> some View {
        HStack {
            Button(action: {
                characterVoice = voiceName
            }) {
                HStack {
                    Image(systemName: characterVoice == voiceName ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(characterVoice == voiceName ? .oshiPink : .oshiTextSecondary)
                    Text(voiceName)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(.oshiTextPrimary)
                    Spacer()
                }
            }

            Button(action: {
                viewModel.playSampleVoice(voiceName: voiceName)
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "play.circle")
                    Text("サンプル再生")
                }
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.oshiPink)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.oshiBackgroundSecondary)
        )
    }
}

#Preview {
    NavigationStack {
        TrainerCreationView()
    }
}
