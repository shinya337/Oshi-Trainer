# Technology Stack - Oshi-Trainer

**Inclusion Mode**: Always

## Architecture

### Application Type
- **Platform**: iOS Native Application
- **UI Framework**: SwiftUI
- **Architecture Pattern**: MVVM (推奨)
- **Minimum Deployment Target**: iOS 15.0+（プロジェクト設定による）

### Design Patterns
- **SwiftUI Declarative UI**: 宣言的UIによる状態管理とビュー構築
- **Combine Framework**: リアクティブプログラミングとデータフロー管理
- **Protocol-Oriented Programming**: Swiftのプロトコル指向設計

### AI & Machine Learning
- **Vision Framework**: カメラベースの姿勢推定とリアルタイムフォーム解析
- **Core ML**: オンデバイス機械学習モデルの実行
- **AVFoundation**: カメラキャプチャとビデオ処理
- **LLM Integration** (Future): 推しトレーナーのパーソナリティ生成とセリフ生成
- **Speech Synthesis** (Future): 推しの声によるフィードバック

## Frontend

### Core Technologies
- **Language**: Swift 5.x
- **UI Framework**: SwiftUI
- **Navigation**: NavigationStack / NavigationView
- **State Management**: @State, @Binding, @ObservableObject, @EnvironmentObject

### UI Components
- **Native SwiftUI Views**: Text, Image, VStack, HStack, etc.
- **SF Symbols**: システムアイコンライブラリ
- **Custom Components**: プロジェクト固有のカスタムビューコンポーネント

## Data & Storage

### Local Storage Options
- **UserDefaults**: 設定や小規模データの永続化
- **Core Data**: 構造化データの永続化（必要に応じて）
- **FileManager**: ファイルベースのデータ管理

### Data Models
- **Swift Structs/Classes**: データモデルの定義
- **Codable Protocol**: JSON エンコード/デコード

## Development Environment

### Required Tools
- **Xcode**: 最新の安定版（14.0+推奨）
- **macOS**: Ventura 13.0+ 以上
- **iOS Simulator**: 開発とテスト用
- **Git**: バージョン管理

### Optional Tools
- **SF Symbols App**: アイコン選択用
- **Instruments**: パフォーマンス分析
- **Physical iOS Device**: 実機テスト

## Common Commands

### Xcode Build & Run
```bash
# コマンドラインビルド（必要に応じて）
xcodebuild -project ios/Oshi-Trainer/Oshi-Trainer.xcodeproj -scheme Oshi-Trainer -configuration Debug

# 通常はXcode IDEから実行
# Cmd + R : ビルドして実行
# Cmd + B : ビルドのみ
# Cmd + U : テスト実行
```

### Testing
```bash
# ユニットテストの実行
xcodebuild test -project ios/Oshi-Trainer/Oshi-Trainer.xcodeproj -scheme Oshi-Trainer -destination 'platform=iOS Simulator,name=iPhone 15'

# 通常はXcode IDEから実行
# Cmd + U : テスト実行
```

### Git Operations
```bash
# 変更の確認
git status

# コミット
git add .
git commit -m "commit message"

# プッシュ
git push origin main
```

## Project Configuration

### Bundle Identifier
- 形式: `com.yourcompany.Oshi-Trainer`
- プロジェクト設定で確認・変更可能

### Build Configurations
- **Debug**: 開発用ビルド設定
- **Release**: リリース用ビルド設定

### Capabilities（今後追加予定）
- **Camera Access**: リアルタイム姿勢推定のための必須機能
- **HealthKit**: フィットネスデータアクセスと統計管理
- **Push Notifications**: 推しからのトレーニング通知
- **Calendar Access**: Googleカレンダー連携による最適なタイミングの通知
- **iCloud**: データ同期とバックアップ
- **Background Modes**: バックグラウンドでの通知処理

## Testing Framework

### Unit Testing
- **XCTest**: Swift標準テストフレームワーク
- **Test Files**:
  - `Oshi_TrainerTests.swift`: ユニットテスト
  - `Oshi_TrainerUITests.swift`: UIテスト
  - `Oshi_TrainerUITestsLaunchTests.swift`: 起動テスト

### Testing Best Practices
- ビジネスロジックのユニットテスト
- UI要素の統合テスト
- TDD（Test-Driven Development）の推奨

## Code Style & Conventions

### Swift Style Guidelines
- SwiftLint（導入推奨）: コードスタイルの一貫性
- Swift API Design Guidelines に準拠
- 命名規則: camelCase for variables/functions, PascalCase for types

### File Organization
- 1ファイル1タイプの原則
- 関連するファイルはグループ化
- テストファイルは対応する実装ファイルと同じ構造

## Performance Considerations

### SwiftUI Optimization
- @State の適切な使用
- 不要な再レンダリングの回避
- Lazy Stack の活用

### Memory Management
- ARC（Automatic Reference Counting）
- Weak/Unowned 参照によるメモリリーク防止

## External Integrations & Services

### Current Stage
現在は外部統合は実装されていませんが、以下の統合が計画されています：

### Future Integrations
- **Google Calendar API**: ユーザーの予定把握と最適なトレーニングタイミングの提案
- **LLM API Integration**: 推しトレーナーのパーソナリティ生成と動的なセリフ生成
  - OpenAI API / Anthropic Claude API / その他のLLMサービス
- **Text-to-Speech Services**: 推しの声によるフィードバック生成
- **Backend Services** (Future):
  - ランキングシステム
  - ユーザー間のデータ共有
  - 推しトレーナーのグローバル統計

### Data Privacy & Security
- **オンデバイス処理優先**: 姿勢推定などはCore MLでオンデバイス実行
- **最小限のデータ送信**: LLM統合時も必要最小限のデータのみを外部送信
- **ユーザー同意**: 外部サービス利用時は明示的な同意を取得

## Dependencies Management

現在、外部依存関係は使用していません。必要に応じて以下のツールで管理：

- **Swift Package Manager (SPM)**: 推奨
  - Vision/Core ML関連の追加ライブラリ
  - ネットワーキングライブラリ（Alamofire等）
  - JSON処理ライブラリ
- **CocoaPods**: 代替オプション
- **Carthage**: 代替オプション

### Planned Dependencies
- **Pose Estimation Models**: Core ML形式の姿勢推定モデル
- **Networking**: APIクライアント（LLM統合用）
- **Calendar Integration**: Google Calendar SDK
- **Analytics** (Optional): ユーザー行動分析
