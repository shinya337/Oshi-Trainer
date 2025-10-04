# Project Structure

## Root Directory Organization

```
Oshi-Trainer/
├── .kiro/                          # Kiro仕様駆動開発
│   ├── specs/                      # 機能仕様書
│   └── steering/                   # プロジェクトステアリング
├── ios/                            # iOSアプリケーション
│   └── Oshi-Trainer/
│       └── Oshi-Trainer/
│           ├── Oshi-Trainer/       # メインアプリ
│           ├── Oshi-TrainerTests/  # ユニットテスト
│           ├── Oshi-TrainerUITests/# UIテスト
│           └── NotificationServiceExtension/ # 通知Service Extension
├── CLAUDE.md                       # Claude Code設定
└── README.md                       # プロジェクト概要
```

## iOS App Structure

```
Oshi-Trainer/
├── Oshi-Trainer/                   # メインアプリターゲット
│   ├── Assets.xcassets/            # 画像・カラーアセット
│   ├── Core/                       # コア機能
│   │   └── Services/              # 共通サービス（将来拡張用）
│   ├── Features/                   # 機能別モジュール
│   │   ├── Home/                   # ホーム画面
│   │   ├── TrainerCreation/        # トレーナー作成
│   │   ├── Settings/               # 設定画面
│   │   ├── LevelDetail/            # レベル詳細
│   │   ├── Statistics/             # 統計画面
│   │   └── Training/               # トレーニング画面
│   ├── Models/                     # データモデル
│   ├── Services/                   # サービスレイヤー
│   │   └── Notifications/          # 通知関連サービス
│   ├── Shared/                     # 共有コンポーネント
│   │   ├── Extensions/             # 拡張機能
│   │   ├── Components/             # 再利用可能UI
│   │   └── Styles/                 # スタイル定義
│   ├── Oshi-Trainer.entitlements   # アプリケーション権限
│   ├── Oshi_TrainerApp.swift       # アプリエントリーポイント
│   └── ContentView.swift           # ルートビュー
└── NotificationServiceExtension/   # Notification Service Extension
    ├── NotificationService.swift   # Extension実装
    ├── Info.plist                  # Extension設定
    └── NotificationServiceExtension.entitlements
```

## Feature Module Structure

各機能は以下の構造で組織化：

```
Feature/
├── Views/          # SwiftUIビュー
├── ViewModels/     # ビューモデル（MVVM）
└── Components/     # 機能固有コンポーネント（オプション）
```

### 例: Home機能

```
Features/Home/
├── Views/
│   ├── HomeView.swift                # メインホーム画面
│   ├── TrainerDetailView.swift       # トレーナー詳細
│   └── TransparentImageView.swift    # 透過画像表示
└── ViewModels/
    └── HomeViewModel.swift           # ホーム画面ロジック
```

## Models Organization

```
Models/
├── OshiTrainer.swift               # トレーナーモデル
├── OshiTrainerTemplate.swift       # トレーナーテンプレート
├── DefaultOshiTrainerData.swift    # デフォルトデータ
├── PersonalityType.swift           # 性格タイプ列挙
├── EncouragementStyle.swift        # 応援スタイル列挙
├── FeedbackFrequency.swift         # フィードバック頻度列挙
├── Achievement.swift               # 達成実績
├── MonthlyStatistic.swift          # 月別統計
└── CategoryStatistic.swift         # 種目別統計
```

## Services Organization

```
Services/
├── DataServiceProtocol.swift       # データサービス抽象化
├── UserDefaultsDataService.swift   # UserDefaults実装
├── ImagePersistenceService.swift   # 画像永続化
└── Notifications/                  # 通知サービス
    ├── NotificationScheduler.swift          # 通知スケジューラ
    ├── INPersonBuilder.swift                # INPerson生成
    ├── INSendMessageIntentBuilder.swift     # Intent生成
    └── NotificationError.swift              # エラー定義
```

## Shared Components

```
Shared/
├── Extensions/                     # Swift拡張
│   ├── Color+Extensions.swift      # カラーパレット
│   └── Font+Extensions.swift       # フォントスタイル
├── Components/                     # 再利用可能UI
│   └── (将来追加予定)
└── Styles/                         # UIスタイル
    ├── OshiButtonStyle.swift       # ボタンスタイル
    └── OshiIconButtonStyle.swift   # アイコンボタンスタイル
```

## File Naming Conventions

### Swift Files
- **Views**: `<機能名>View.swift` (例: `HomeView.swift`)
- **ViewModels**: `<機能名>ViewModel.swift` (例: `HomeViewModel.swift`)
- **Models**: `<モデル名>.swift` (例: `OshiTrainer.swift`)
- **Services**: `<サービス名>Service.swift` (例: `ImagePersistenceService.swift`)
- **Extensions**: `<型名>+<拡張内容>.swift` (例: `Color+Extensions.swift`)
- **Protocols**: `<プロトコル名>Protocol.swift` (例: `DataServiceProtocol.swift`)
- **Enums**: `<列挙名>.swift` (例: `PersonalityType.swift`)

### Asset Files
- **Images**: ケバブケース (例: `Oshino-Ai`, `oshi_create`)
- **Colors**: キャメルケース (例: `oshiBackground`, `oshiPink`)

### Directories
- 機能名は大文字始まり (例: `Home`, `TrainerCreation`)
- 複数形を使用 (例: `Models`, `Services`, `Views`)

## Import Organization

### Import順序
1. Foundation/UIKit/SwiftUI（システムフレームワーク）
2. サードパーティライブラリ（将来）
3. アプリ内モジュール

### 例
```swift
import SwiftUI
import Combine
import UserNotifications

// アプリ内のimportは不要（同一モジュール）
```

## Code Organization Patterns

### MVVM Pattern
- **View**: UIロジックのみ、ビジネスロジックなし
- **ViewModel**: `@Published`プロパティでStateを管理
- **Model**: イミュータブルな構造体（`struct`）、`Codable`準拠

### Protocol-Oriented
- サービスはProtocolで抽象化
- テスト時のモック差し替えを考慮
- 実装は`<Protocol名>Protocol`命名

### Dependency Injection
```swift
class HomeViewModel: ObservableObject {
    private let dataService: DataServiceProtocol

    init(dataService: DataServiceProtocol = UserDefaultsDataService()) {
        self.dataService = dataService
    }
}
```

## Key Architectural Principles

### 1. Feature-Based Organization
機能単位でディレクトリを分割し、関連するView/ViewModel/Componentsをまとめる。

### 2. Separation of Concerns
- UI層（View）
- ビジネスロジック層（ViewModel）
- データ層（Service）
- モデル層（Model）

を明確に分離。

### 3. Reusability
- 共通UIコンポーネントは`Shared/Components/`
- 共通スタイルは`Shared/Styles/`
- 共通拡張は`Shared/Extensions/`

### 4. App Group Data Sharing
メインアプリとNotification Service Extension間でデータ共有：
- UserDefaults: `UserDefaults(suiteName: "group.com.yourcompany.VirtualTrainer")`
- FileManager: `FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:)`

### 5. Communication Notifications Integration
- INPerson + INSendMessageIntentでトレーナー情報を表現
- 通知アイコンにトレーナー画像を表示
- スケール・オフセット調整でアイコン表示を最適化

## Asset Organization

### Assets.xcassets Structure
```
Assets.xcassets/
├── AppIcon.appiconset/             # アプリアイコン
├── AccentColor.colorset/           # アクセントカラー
├── Colors/                         # カラーパレット
│   ├── oshiBackground.colorset/
│   ├── oshiPink.colorset/
│   └── ...
└── Images/                         # 画像アセット
    ├── Oshino-Ai.imageset/         # デフォルトトレーナー
    └── oshi_create.imageset/       # 作成プレースホルダー
```

### App Group Container
```
App Group Container/
└── TrainerImages/                  # ユーザー作成トレーナー画像
    ├── <UUID>.png                  # トレーナー画像
    └── Oshino-Ai.png              # コピーされたデフォルト画像
```

## Testing Structure

```
Oshi-TrainerTests/
├── HomeViewModelTests.swift        # ユニットテスト例
└── (将来追加予定)

Oshi-TrainerUITests/
└── (将来追加予定)
```

## Build Targets

- **Oshi-Trainer**: メインアプリケーション
- **NotificationServiceExtension**: 通知Service Extension
- **Oshi-TrainerTests**: ユニットテスト
- **Oshi-TrainerUITests**: UIテスト
