# ウマ娘風UIデザインリファレンス

本ドキュメントは、Oshi-TrainerアプリのUI実装時に参照すべきウマ娘プリティーダービーのデザイン原則をまとめたものです。

## レイアウト原則

### 画面構成
- **中央配置キャラクター**: 3Dキャラクターを画面中央に配置し、全身を表示
- **ボトムUI**: 重要なUI要素を画面下部に配置（片手操作を考慮）
- **ヘッダー情報**: レベル、経験値などの重要な情報を上部に配置
- **曲線的なデザイン**: アイコン配置やボタンに曲線を使用し、遊び心と柔らかさを表現

### 情報階層
- **ヘッダー**: ゲーム全体の状態（レベル、経験値、目標）
- **サブ情報**: キャラクタービジュアル、セリフ
- **メイン情報**: コアゲームプレイコマンド、パラメータ
- **フッター**: ナビゲーション、ログ、メニュー

## 配色戦略

### カラーパレット
- **ベースカラー（70%）**: 白と青みがかったグレー
  - 目的: 明るく清潔な印象を与える
  - SwiftUI実装: `Color.white`, `Color(white: 0.95)`

- **メインカラー（25%）**: 緑色
  - 目的: 競馬場の芝生を連想させる
  - SwiftUI実装: `Color.green`, カスタムグリーングラデーション

- **アクセントカラー（5%）**: オレンジまたはピンク
  - 目的: 活気と魅力を表現
  - SwiftUI実装: `Color.orange`, `Color.pink`

### グラデーション
- 緑色の要素に明るいグラデーションを適用
- ボタンやカードに深度感を与える

## タイポグラフィ

### フォントスタイル
- **ゴシック体**: 安定感と均一な太さ、遊び心のあるデザイン
- SwiftUI実装: `.font(.system(.body, design: .rounded))` または `.bold()`

### フォントサイズ
- **数値表示**: 26-28pt (SwiftUI: `.font(.system(size: 26))`)
- **メインボタン**: 32-42pt (SwiftUI: `.font(.system(size: 36))`)
- **一般テキスト**: 16-20pt (SwiftUI: `.font(.body)`)

### 読みやすさ
- 大きなフォントサイズを使用
- 明確な階層構造
- 十分なコントラスト

## インタラクション設計

### ユーザビリティ
- **片手操作**: 重要なUI要素を親指の届く範囲（画面下部）に配置
- **直感的なナビゲーション**: ユーザーが迷わず選択できる情報提示
- **即座のフィードバック**: タップ時のアニメーションやサウンド

### キャラクター相互作用
- 背景のキャラクターをタップして会話表示
- セリフは吹き出しスタイルで表示
- キャラクターとの距離感を縮める

## UI要素のデザイン

### ボタン
- 曲線的なデザイン（角丸）
- 大きく押しやすいサイズ
- 明確なラベルとアイコン
- タップ時のスケールアニメーション

### カード
- 白背景に軽いシャドウ
- 角丸デザイン
- 情報の明確なグルーピング

### アイコン
- カラフルなキャラクターイラストを優先
- ピクトグラムは補助的に使用
- SF Symbolsとカスタムアイコンの併用

## SwiftUI実装例

### カラーパレット定義
```swift
extension Color {
    static let oshiBackground = Color(white: 0.95)
    static let oshiGreen = Color.green
    static let oshiAccent = Color.orange
}
```

### ボタンスタイル
```swift
struct OshiButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 36, weight: .bold, design: .rounded))
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.oshiGreen, Color.oshiGreen.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .foregroundColor(.white)
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}
```

### レイアウト例
```swift
struct HomeView: View {
    var body: some View {
        ZStack {
            // 背景
            Color.oshiBackground.ignoresSafeArea()

            VStack {
                // ヘッダー
                HStack {
                    Text("Lv. 10")
                        .font(.system(size: 28, weight: .bold))
                    Spacer()
                    Button("推し作成") { }
                }
                .padding()

                Spacer()

                // 中央：キャラクター
                // （キャラクター画像とセリフ欄）

                Spacer()

                // フッター：曲線的なボタン配置
                HStack {
                    Button("統計") { }
                    Spacer()
                    Button("設定") { }
                }
                .padding()
            }
        }
    }
}
```

## デザインチェックリスト

実装時に以下を確認：
- [ ] ベースカラー（白/青グレー）が70%を占めているか
- [ ] メインカラー（緑）が25%程度使用されているか
- [ ] アクセントカラー（オレンジ/ピンク）が効果的に使用されているか
- [ ] フォントサイズは読みやすいか（26-42pt）
- [ ] 重要なUI要素は画面下部に配置されているか
- [ ] ボタンは曲線的なデザインか
- [ ] タップフィードバックは実装されているか
- [ ] キャラクターとの相互作用は直感的か
