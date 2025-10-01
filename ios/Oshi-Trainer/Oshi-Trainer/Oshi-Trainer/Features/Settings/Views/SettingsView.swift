import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color.oshiBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // アプリ設定
                    settingsSection

                    // クレジット情報
                    creditsSection

                    // バージョン情報
                    versionSection
                }
                .padding()
            }
        }
        .navigationTitle("設定")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("アプリ設定")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.oshiTextPrimary)

            VStack(spacing: 0) {
                settingRow(
                    icon: "bell.fill",
                    title: "通知設定",
                    color: .oshiAccent
                )
                Divider().padding(.leading, 56)

                settingRow(
                    icon: "moon.fill",
                    title: "ダークモード",
                    color: .purple
                )
                Divider().padding(.leading, 56)

                settingRow(
                    icon: "person.fill",
                    title: "プロフィール設定",
                    color: .blue
                )
                Divider().padding(.leading, 56)

                settingRow(
                    icon: "lock.fill",
                    title: "プライバシー",
                    color: .oshiGreen
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.oshiBackgroundSecondary)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
    }

    // MARK: - Credits Section
    private var creditsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("クレジット")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.oshiTextPrimary)

            VStack(alignment: .leading, spacing: 12) {
                Text("推しトレ")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.oshiAccentSecondary)

                Text("推しと一緒にトレーニングを楽しむアプリケーション")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.oshiTextSecondary)

                Divider()
                    .padding(.vertical, 8)

                VStack(alignment: .leading, spacing: 8) {
                    creditItem(title: "開発", value: "Team タカ＆マサ")
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.oshiBackgroundSecondary)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
    }

    // MARK: - Version Section
    private var versionSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "heart.fill")
                .font(.system(size: 40))
                .foregroundColor(.oshiAccentSecondary)

            Text("Version 1.0.0")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.oshiTextSecondary)

            Text("© 2025 推しトレ")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.oshiTextSecondary.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.oshiBackgroundSecondary)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    // MARK: - Helper Views
    private func settingRow(icon: String, title: String, color: Color) -> some View {
        Button(action: {
            // プレースホルダー：実際の設定画面への遷移
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 32)

                Text(title)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.oshiTextPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.oshiTextSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    private func creditItem(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.oshiTextSecondary)
                .frame(width: 80, alignment: .leading)

            Text(value)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.oshiTextPrimary)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
