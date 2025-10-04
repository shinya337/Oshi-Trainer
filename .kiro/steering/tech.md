# Technology Stack

## Architecture

**ネイティブiOSアプリケーション**
- SwiftUI + MVVM アーキテクチャ
- App Group共有ストレージ（メインアプリ ⇄ Notification Service Extension）
- Communication Notifications API統合（iOS 15+）

## Frontend

### UI Framework
- **SwiftUI** - 宣言的UIフレームワーク
- **Combine** - リアクティブプログラミング（ObservableObject）

### デザインシステム
- カスタムカラーパレット（`Color+Extensions.swift`）
  - `oshiBackground`, `oshiBackgroundSecondary`
  - `oshiTextPrimary`, `oshiTextSecondary`
  - `oshiAccent`, `oshiAccentSecondary`
  - 動的テーマカラー（pink, blue, green, orange, purple）
- カスタムフォントスタイル（`Font+Extensions.swift`）
  - `oshiNumberStyle()`, `oshiHeadlineStyle()`
- カスタムボタンスタイル
  - `OshiButtonStyle`, `OshiIconButtonStyle`

### 画像処理
- `UIImage` - トレーナー画像の読み込み・加工
- `UIGraphicsImageRenderer` - 通知アイコン用画像生成
- PNG形式での保存・読み込み

## Backend / Services

### データ永続化
- **UserDefaults** - トレーナーテンプレート、設定の保存
- **App Group UserDefaults** - Extension間データ共有
  - App Group ID: `group.com.yourcompany.VirtualTrainer`
- **FileManager** - トレーナー画像の保存
  - App Groupコンテナ: `TrainerImages/`ディレクトリ

### 通知システム
- **UNUserNotificationCenter** - ローカル通知管理
- **Communication Notifications API** (iOS 15+)
  - `INPerson` - トレーナー情報の表現
  - `INSendMessageIntent` - メッセージ通知Intent
  - `content.updating(from:)` - Intentから通知コンテンツ生成
- **Notification Service Extension** - リモート通知対応（将来用）

### サービスレイヤー
- `DataServiceProtocol` - データアクセス抽象化
- `UserDefaultsDataService` - UserDefaults実装
- `ImagePersistenceService` - 画像保存・読み込み
- `NotificationScheduler` - 通知スケジューリング
- `INPersonBuilder` - INPerson生成（スケール・オフセット調整）
- `INSendMessageIntentBuilder` - INSendMessageIntent生成

## Development Environment

### 必須ツール
- **Xcode** 15.0+ - iOS開発IDE
- **iOS Simulator** または 実機（iOS 16.0+）
- **Git** - バージョン管理

### 開発言語
- **Swift** 5.9+
- **SwiftUI** - UIフレームワーク

### ビルド設定
- Deployment Target: **iOS 16.0**
- Swift Language Version: **Swift 5**

## Project Configuration

### Capabilities
- **Communication Notifications**
  - Entitlement: `com.apple.developer.usernotifications.communication`
- **App Groups**
  - Group ID: `group.com.yourcompany.VirtualTrainer`
- **Push Notifications**（準備済み）

### Entitlements
- **メインアプリ**: `Oshi-Trainer.entitlements`
  - Communication Notifications
  - App Groups
- **Notification Service Extension**: `NotificationServiceExtension.entitlements`
  - App Groups

### Info.plist設定
- **NSUserActivityTypes**: `INSendMessageIntent`
  - Communication Notifications donateに必要

## Common Commands

### ビルド・実行
```bash
# Xcodeでプロジェクトを開く
open ios/Oshi-Trainer/Oshi-Trainer/Oshi-Trainer.xcodeproj

# シミュレータでビルド（コマンドライン）
xcodebuild -scheme Oshi-Trainer -destination 'platform=iOS Simulator,name=iPhone 15' build

# 実機でビルド
# Xcodeから直接実行（通知機能は実機推奨）
```

### テスト
```bash
# ユニットテスト実行
xcodebuild test -scheme Oshi-Trainer -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Git操作
```bash
# ブランチ作成
git checkout -b feature/new-feature

# コミット
git add .
git commit -m "feat: 新機能の実装"

# プッシュ
git push origin feature/new-feature
```

## Environment Variables

現在、環境変数は使用していません。将来的なバックエンド統合時に追加予定。

## Port Configuration

ローカル開発では特定のポート設定は不要（ネイティブiOSアプリのため）。

## Dependencies

### iOS Frameworks
- **SwiftUI** - UIフレームワーク
- **Combine** - リアクティブプログラミング
- **UserNotifications** - 通知管理
- **Intents** - Communication Notifications
- **UIKit** - 画像処理
- **Foundation** - 基本機能
- **os.log** - ロギング（Notification Service Extension）

### 外部ライブラリ
現在、外部パッケージマネージャ（CocoaPods, SPM）は使用していません。すべてネイティブフレームワークで実装。

## Code Organization Principles

### MVVM パターン
- **Model**: データ構造（`OshiTrainer`, `OshiTrainerTemplate`）
- **View**: SwiftUIビュー（`HomeView`, `SettingsView`）
- **ViewModel**: ビジネスロジック（`HomeViewModel`, `SettingsViewModel`）

### Protocol-Oriented Programming
- `DataServiceProtocol` - データアクセスの抽象化
- `NotificationSchedulerProtocol` - 通知スケジューリングの抽象化

### Dependency Injection
- ViewModelでサービスをインスタンス化
- テスト時のモック差し替えを考慮

## Development Workflow

### 推奨開発フロー
1. Spec-Driven Development（仕様駆動開発）
   - `.kiro/specs/` で要件・設計を定義
   - `/kiro:spec-init`, `/kiro:spec-requirements`, `/kiro:spec-design` コマンド使用
2. タスク分割（`tasks.md`）
3. TDD（テスト駆動開発）- 将来実装
4. 実装
5. コミット

### ブランチ戦略
- `main` - 本番用ブランチ
- `feature/*` - 機能開発ブランチ
- `fix/*` - バグ修正ブランチ
