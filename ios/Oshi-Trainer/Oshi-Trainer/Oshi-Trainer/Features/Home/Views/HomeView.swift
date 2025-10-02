import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showLevelDetail = false
    @State private var showTrainingPopup = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // 背景
                Color.oshiBackground
                    .ignoresSafeArea()
                    .zIndex(-1)

                // 動的テーマカラーグラデーション背景
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        Spacer()
                        LinearGradient(
                            colors: [
                                Color.oshiThemeColor(from: viewModel.oshiTemplate.themeColor).opacity(0.3),
                                Color.oshiThemeColorLight(from: viewModel.oshiTemplate.themeColor).opacity(0.15),
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
                .zIndex(-0.5)

                VStack(spacing: 0) {
                    // ヘッダー
                    headerView
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .zIndex(2)

                    Spacer()
                }

                // キャラクター画像（下から上に大きく表示）
                characterImageLayer
                    .zIndex(0)

                // セリフ欄とフッター
                VStack(spacing: 0) {
                    Spacer()

                    // セリフ欄
                    dialogueBubble
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)

                    // フッター：ナビゲーションボタン
                    footerView
                        .padding(.horizontal, 32)
                        .padding(.bottom, 32)
                }
                .zIndex(1)
            }
            .sheet(isPresented: $showLevelDetail) {
                LevelDetailView(themeColor: viewModel.oshiTemplate.themeColor)
            }
            .sheet(isPresented: $showTrainingPopup) {
                TrainingPopupView()
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

    // MARK: - Character Image Layer (下から生えている感じ)
    private var characterImageLayer: some View {
        GeometryReader { geometry in
            // キャラクター画像（透過PNG、アルファヒット判定付き）
            HStack {
                Spacer()
                TransparentImageView(
                    imageName: viewModel.oshiTrainer.imageName,
                    onTap: {
                        showTrainingPopup = true
                        viewModel.updateDialogue(for: .trainingStart)
                    }
                )
                .frame(height: geometry.size.height * 0.7)
                .scaleEffect(1.6) // 160%のサイズ
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
            .position(x: geometry.size.width / 2, y: geometry.size.height - (geometry.size.height * 0.7 / 2))
            .scaleEffect(showTrainingPopup ? 0.98 : 1.0)
            .animation(.spring(response: 0.3), value: showTrainingPopup)
        }
    }

    // MARK: - Dialogue Bubble
    private var dialogueBubble: some View {
        VStack(spacing: 4) {
            // キャラ名
            Text(viewModel.oshiTrainer.name)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.oshiTextSecondary)

            // セリフ
            Text(viewModel.currentDialogue)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.oshiTextPrimary)
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

    // MARK: - Footer
    private var footerView: some View {
        HStack {
            // 左下：統計ボタン
            NavigationLink(destination: StatisticsView(themeColor: viewModel.oshiTemplate.themeColor)) {
                VStack(spacing: 4) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 32))
                    Text("統計")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
            }
            .buttonStyle(OshiIconButtonStyle(size: 32, accentColor: Color.oshiThemeColor(from: viewModel.oshiTemplate.themeColor)))

            Spacer()

            // 右下：推しボタン（推しの情報・作成）
            Button(action: {
                showLevelDetail = true
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 32))
                    Text("推し")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
            }
            .buttonStyle(OshiIconButtonStyle(size: 32, accentColor: Color.oshiThemeColor(from: viewModel.oshiTemplate.themeColor)))
        }
    }
}

#Preview {
    HomeView()
}
