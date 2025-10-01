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
                LevelDetailView()
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

            // 右上：推し作成ボタン
            NavigationLink(destination: TrainerCreationView()) {
                HStack(spacing: 4) {
                    Image(systemName: "person.badge.plus")
                    Text("推し作成")
                }
                .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .buttonStyle(OshiSecondaryButtonStyle(size: 16))
        }
    }

    // MARK: - Character Image Layer (下から生えている感じ)
    private var characterImageLayer: some View {
        GeometryReader { geometry in
            Button(action: {
                showTrainingPopup = true
                viewModel.updateDialogue()
            }) {
                VStack(spacing: 0) {
                    Spacer()

                    ZStack(alignment: .bottom) {
                        // グラデーション背景（下から上へ）
                        LinearGradient(
                            colors: [
                                Color.oshiGreen.opacity(0.3),
                                Color.oshiGreen.opacity(0.1),
                                Color.clear
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(height: geometry.size.height * 0.7)

                        // キャラクター画像（縦長、下部が切れる）
                        Image(systemName: viewModel.oshiTrainer.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.75)
                            .foregroundColor(.oshiGreen.opacity(0.8))
                            .offset(y: geometry.size.height * 0.15) // 下にオフセットして下部を切る
                    }
                }
            }
            .scaleEffect(showTrainingPopup ? 0.98 : 1.0)
            .animation(.spring(response: 0.3), value: showTrainingPopup)
        }
    }

    // MARK: - Dialogue Bubble
    private var dialogueBubble: some View {
        Text(viewModel.currentDialogue)
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .foregroundColor(.oshiTextPrimary)
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
            NavigationLink(destination: StatisticsView()) {
                VStack(spacing: 4) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 32))
                    Text("統計")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
            }
            .buttonStyle(OshiIconButtonStyle(size: 32))

            Spacer()

            // 右下：設定ボタン
            NavigationLink(destination: SettingsView()) {
                VStack(spacing: 4) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 32))
                    Text("設定")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
            }
            .buttonStyle(OshiIconButtonStyle(size: 32))
        }
    }
}

#Preview {
    HomeView()
}
