# Project Structure - Oshi-Trainer

**Inclusion Mode**: Always

## Root Directory Organization

```
Oshi-Trainer/
├── ios/                          # iOSアプリケーション本体
│   └── Oshi-Trainer/            # Xcodeプロジェクトディレクトリ
├── .kiro/                        # Kiro仕様駆動開発関連
│   ├── steering/                # ステアリングドキュメント
│   └── specs/                   # 機能仕様書
├── .claude/                      # Claude Code設定
│   └── commands/                # カスタムスラッシュコマンド
├── README.md                     # プロジェクト概要
└── CLAUDE.md                     # Claude Code プロジェクト指示
```

## iOS Application Structure

### Xcode Project Layout

```
ios/Oshi-Trainer/Oshi-Trainer/
├── Oshi-Trainer.xcodeproj/                    # Xcodeプロジェクトファイル
│   ├── project.pbxproj                       # プロジェクト設定
│   └── xcuserdata/                           # ユーザー固有設定
├── Oshi-Trainer/                              # メインアプリケーションターゲット
│   ├── Oshi_TrainerApp.swift                 # アプリケーションエントリーポイント
│   ├── ContentView.swift                     # メインビュー（初期テンプレート）
│   └── Assets.xcassets/                      # アセットカタログ
│       ├── AppIcon.appiconset/               # アプリアイコン
│       ├── AccentColor.colorset/             # アクセントカラー
│       └── Contents.json                     # アセットメタデータ
├── Oshi-TrainerTests/                         # ユニットテストターゲット
│   └── Oshi_TrainerTests.swift               # テストケース
└── Oshi-TrainerUITests/                       # UIテストターゲット
    ├── Oshi_TrainerUITests.swift             # UIテストケース
    └── Oshi_TrainerUITestsLaunchTests.swift  # 起動テスト
```

## Code Organization Patterns

### Recommended Directory Structure (今後の開発向け)

```
Oshi-Trainer/
├── App/
│   └── Oshi_TrainerApp.swift              # アプリケーションエントリーポイント
├── Features/                               # 機能別モジュール（推奨）
│   ├── AICompanion/                       # AIコンパニオン機能
│   │   ├── Views/                         # フォームチェック画面、応援画面
│   │   ├── ViewModels/                    # AIコンパニオンのビジネスロジック
│   │   └── Services/                      # 姿勢推定、LLM統合
│   ├── WorkoutTracking/                   # トレーニング記録機能
│   │   ├── Views/                         # トレーニング画面
│   │   ├── ViewModels/                    # トレーニングロジック
│   │   └── Models/                        # ワークアウトデータモデル
│   ├── Statistics/                        # 統計機能（Future）
│   │   ├── Views/                         # 統計表示画面
│   │   └── ViewModels/                    # 統計計算ロジック
│   ├── OshiTrainer/                       # 推しトレーナー管理（Future）
│   │   ├── Views/                         # トレーナー作成・カスタマイズ画面
│   │   ├── ViewModels/                    # トレーナー管理ロジック
│   │   └── Models/                        # トレーナーデータモデル
│   └── Notifications/                     # 通知機能（Future）
│       ├── Views/                         # 通知設定画面
│       └── Services/                      # カレンダー連携、通知スケジューリング
├── Core/                                   # コア機能（共通）
│   ├── Vision/                            # 姿勢推定・カメラ処理
│   │   ├── PoseEstimator.swift           # 姿勢推定エンジン
│   │   ├── CameraManager.swift           # カメラ管理
│   │   └── Models/                        # Core MLモデル
│   ├── AI/                                # AI/LLM統合（Future）
│   │   ├── LLMService.swift              # LLM API クライアント
│   │   └── PersonalityEngine.swift       # パーソナリティ生成
│   └── Data/                              # データ永続化
│       ├── CoreDataStack.swift           # Core Data管理
│       └── UserDefaultsManager.swift     # 設定管理
├── Shared/                                 # 共有コンポーネント
│   ├── Views/                             # 再利用可能なUIコンポーネント
│   ├── Models/                            # 共通データモデル
│   └── ViewModels/                        # 共有ビューモデル
├── Services/                               # グローバルサービス
│   ├── DataService.swift                  # データ管理サービス
│   ├── CalendarService.swift             # カレンダー統合（Future）
│   └── NotificationService.swift         # 通知管理（Future）
├── Utilities/
│   ├── Extensions/                        # Swift型の拡張
│   └── Helpers/                           # ヘルパー関数・ユーティリティ
├── Resources/
│   ├── Assets.xcassets/                   # 画像・カラー・アセット
│   └── MLModels/                          # Core MLモデルファイル
└── Constants/
    └── AppConstants.swift                 # アプリ全体の定数
```

## File Naming Conventions

### Swift Files
- **Views**: `{Feature}View.swift`
  - 例: `WorkoutView.swift`, `ProfileView.swift`
- **ViewModels**: `{Feature}ViewModel.swift`
  - 例: `WorkoutViewModel.swift`
- **Models**: `{Entity}.swift` または `{Entity}Model.swift`
  - 例: `Workout.swift`, `User.swift`
- **Services**: `{Purpose}Service.swift`
  - 例: `DataService.swift`, `NetworkService.swift`
- **Extensions**: `{Type}+{Extension}.swift`
  - 例: `String+Validation.swift`, `Color+Theme.swift`

### Test Files
- **Unit Tests**: `{TargetFile}Tests.swift`
  - 例: `WorkoutViewModelTests.swift`
- **UI Tests**: `{Feature}UITests.swift`
  - 例: `WorkoutUITests.swift`

## Import Organization

### Import Order
1. Foundation/UIKit/SwiftUIなどのシステムフレームワーク
2. サードパーティライブラリ
3. プロジェクト内モジュール

```swift
// システムフレームワーク
import SwiftUI
import Combine

// サードパーティライブラリ（将来）
// import SomeThirdPartyLibrary

// プロジェクト内モジュール
import Models
import Services
```

## Key Architectural Principles

### 1. SwiftUI-First Approach
- SwiftUIを主要なUI構築フレームワークとして使用
- UIKitは必要な場合のみ使用（UIViewRepresentableでラップ）

### 2. MVVM Pattern
```
View (SwiftUI) ←→ ViewModel (ObservableObject) ←→ Model/Service
```
- **View**: UIの表示とユーザーインタラクション
- **ViewModel**: ビジネスロジックと状態管理
- **Model**: データ構造とビジネスエンティティ

### 3. Separation of Concerns
- UI層、ビジネスロジック層、データ層の明確な分離
- 各コンポーネントは単一責任の原則に従う

### 4. Protocol-Oriented Programming
- プロトコルを使用した抽象化
- テスタビリティとモックの容易性

### 5. State Management Strategy
- **Local State**: `@State` for view-local state
- **Shared State**: `@StateObject` / `@ObservedObject` for shared state
- **Environment**: `@EnvironmentObject` for app-wide state
- **Dependency Injection**: ViewModelやServiceの注入

### 6. Feature-Based Modularization（機能別モジュール化）
- **機能ごとの独立性**: 各Featureモジュールは独立して動作可能
- **明確な責任範囲**: 各モジュールは単一の機能領域に責任を持つ
- **疎結合**: Serviceレイヤーを通じた機能間の通信
- **段階的実装**: 将来機能はディレクトリ構造に含めるが、段階的に実装

### 7. AI Companion Architecture（AIコンパニオン設計）
AIコンパニオン機能は以下の層で構成：

```
UI Layer (SwiftUI Views)
    ↓
ViewModel Layer (Business Logic)
    ↓
Service Layer
    ├── PoseEstimator (Vision Framework)
    ├── FeedbackGenerator (リアルタイムフィードバック)
    └── LLMService (将来: パーソナリティ生成)
    ↓
Core ML Models / External APIs
```

- **リアルタイム処理**: カメラフレーム処理とVision分析は非同期処理
- **パフォーマンス最適化**: Core MLモデルのオンデバイス実行で低レイテンシを実現
- **フィードバック設計**: 姿勢推定結果を即座にUIに反映

## Testing Organization

### Test File Location
- テストファイルは実装ファイルと同じ構造を反映
- `Oshi-TrainerTests/` 配下に実装と同じディレクトリ構造を作成

### Test Naming Convention
```swift
// テスト関数命名: test_{対象機能}_{条件}_{期待結果}
func test_saveWorkout_withValidData_savesSuccessfully()
func test_validateUser_withEmptyName_returnsFalse()
```

## Asset Organization

### Assets.xcassets Structure
```
Assets.xcassets/
├── AppIcon.appiconset/          # アプリアイコン
├── AccentColor.colorset/        # メインアクセントカラー
├── Colors/                      # カラーアセット
│   ├── Primary.colorset/
│   └── Secondary.colorset/
├── Images/                      # 画像アセット
│   ├── Oshi/                   # 推し関連画像
│   └── Workout/                # ワークアウト関連画像
└── Icons/                       # カスタムアイコン
```

## Build Configuration Structure

### Debug vs Release
- **Debug**: 開発用、詳細ログ、デバッグシンボル有効
- **Release**: リリース用、最適化、ログ最小限

### Configuration Files
- プロジェクト設定は `project.pbxproj` に記述
- 環境別設定は `.xcconfig` ファイルで管理（将来）

## Version Control Strategy

### Git Ignore Patterns
重要：以下はバージョン管理から除外すべき
- `xcuserdata/` - ユーザー固有設定
- `*.xcuserstate` - Xcodeワークスペース状態
- `DerivedData/` - ビルド成果物
- `.DS_Store` - macOSシステムファイル

### Commit Organization
- 機能ごとの論理的なコミット
- 明確なコミットメッセージ（日本語または英語）
- spec-driven developmentに従った段階的コミット
