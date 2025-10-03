import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showLevelDetail = false
    @State private var showTrainingPopup = false
    @State private var showTrainerDetail = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // 背景
                Color.oshiBackground
                    .ignoresSafeArea()
                    .zIndex(-1)

                // 動的テーマカラーグラデーション背景
                themeGradientBackground
                    .zIndex(-0.5)

                VStack(spacing: 0) {
                    // ヘッダー
                    headerView
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .zIndex(2)

                    Spacer()
                }

                // TabView でスワイプ切り替え可能なキャラクター画像
                TabView(selection: $viewModel.currentTrainerIndex) {
                    ForEach(Array(viewModel.trainers.enumerated()), id: \.element.id) { index, trainer in
                        characterImageLayer(for: trainer)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                .zIndex(0)

                // セリフ欄
                VStack(spacing: 0) {
                    Spacer()

                    dialogueBubble
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                }
                .zIndex(1)
            }
            .sheet(isPresented: $showLevelDetail) {
                LevelDetailView(themeColor: viewModel.currentTemplate.themeColor)
            }
            .sheet(isPresented: $showTrainingPopup) {
                TrainingPopupView()
            }
            .sheet(isPresented: $showTrainerDetail) {
                TrainerDetailView(
                    trainer: viewModel.currentTrainer,
                    template: viewModel.currentTemplate
                )
            }
        }
    }

    // MARK: - Header
    private var headerView: some View {
        HStack {
            // 左上：推しレベル
            Button(action: {
                showLevelDetail = true
            }) {
                HStack(spacing: 8) {
                    Text("Lv.")
                        .oshiNumberStyle()
                        .foregroundColor(.oshiTextSecondary)
                    Text("\(viewModel.oshiLevel)")
                        .oshiNumberStyle()
                        .foregroundColor(.oshiTextPrimary)
                }
            }
            .buttonStyle(OshiIconButtonStyle())

            Spacer()

            // 右上：設定ボタン
            NavigationLink(destination: SettingsView(themeColor: viewModel.oshiTemplate.themeColor)) {
                VStack(spacing: 4) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 32))
                    Text("設定")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
            }
            .buttonStyle(OshiIconButtonStyle(size: 32, accentColor: Color.oshiThemeColor(from: viewModel.oshiTemplate.themeColor)))
        }
    }

    // MARK: - Theme Gradient Background

    private var themeGradientBackground: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                LinearGradient(
                    colors: [
                        Color.oshiThemeColor(from: viewModel.currentTemplate.themeColor).opacity(0.3),
                        Color.oshiThemeColorLight(from: viewModel.currentTemplate.themeColor).opacity(0.15),
                        Color.clear
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: geometry.size.height * 0.7)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .allowsHitTesting(false)
    }

    // MARK: - Character Image Layer (下から生えている感じ)

    private func characterImageLayer(for trainer: OshiTrainer) -> some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                if viewModel.isAddPlaceholder(trainer) {
                    // 推し追加プレースホルダー画像
                    Image("oshi_create")
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometry.size.height * 0.7)
                        .scaleEffect(1.6)
                        .onTapGesture {
                            // 推し追加ビューへ遷移（今後実装）
                            print("推し追加画面へ遷移")
                        }
                } else {
                    // 通常のトレーナー画像
                    TransparentImageView(
                        imageName: trainer.imageName,
                        onTap: {
                            showTrainerDetail = true
                        }
                    )
                    .frame(height: geometry.size.height * 0.7)
                    .scaleEffect(1.6)
                }
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
            .position(x: geometry.size.width / 2, y: geometry.size.height - (geometry.size.height * 0.7 / 2))
        }
    }

    // MARK: - Dialogue Bubble

    private var dialogueBubble: some View {
        VStack(spacing: 4) {
            // キャラ名
            Text(viewModel.currentTrainer.name)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.oshiTextSecondary)

            if viewModel.isAddPlaceholder(viewModel.currentTrainer) {
                // 推し追加プレースホルダー用ボタン
                Button("キャラを作成する") {
                    // 推し追加ビューへ遷移（今後実装）
                    print("推し追加画面へ遷移")
                }
                .buttonStyle(OshiButtonStyle())
                .padding(.top, 8)
            } else {
                // 通常のメッセージ（タップでトレーニング選択へ）
                Text(viewModel.currentDialogue)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.oshiTextPrimary)
                    .onTapGesture {
                        showTrainingPopup = true
                        viewModel.updateDialogue(for: .trainingStart)
                    }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.oshiBackgroundSecondary)
                .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
        )
        .multilineTextAlignment(.center)
    }
}

#Preview {
    HomeView()
}
