# Project Structure - Oshi-Trainer

**Inclusion Mode**: Always

## Root Directory Organization

```
Oshi-Trainer/
├── ios/                          # iOSアプリケーション本体
│   └── Oshi-Trainer/            # Xcodeプロジェクトディレクトリ
├── python/                       # 🧪 姿勢推定プロトタイプ（実験中）
│   ├── main_overheadpress.py    # オーバーヘッドプレス姿勢解析スクリプト
│   ├── convert_models.py        # YOLOモデルのCore ML変換ユーティリティ
│   ├── yolo11n-pose.pt          # YOLOv11 Poseモデルファイル（6.2MB）
│   └── .venv/                   # Python仮想環境
├── 参考プログラム/                # 📚 リアルタイムフォーム解析の参考実装
│   ├── CameraManager.swift      # カメラセッション管理の参考実装
│   ├── MLModelManager.swift     # Core ML推論管理の参考実装
│   └── ExerciseTrainingView.swift # トレーニング画面UIの参考実装
├── audio/                        # 🎵 音声アセット
│   └── ずんだもん/               # ずんだもん音声ファイル（48ファイル）
│       ├── rep_count/           # レップカウント音声（1〜40）
│       ├── timer/               # タイマー音声（開始、残り時間、完了）
│       ├── form_error/          # フォームエラー音声
│       └── speed/               # 速度フィードバック音声
├── .kiro/                        # Kiro仕様駆動開発関連
│   ├── steering/                # ステアリングドキュメント
│   └── specs/                   # 機能仕様書
│       ├── oshi-trainer-frontend-ui/      # ホーム画面UI仕様
│       ├── default-oshi-trainer/          # デフォルトトレーナー仕様
│       └── oshi-trainer-template/         # 推しトレーナーテンプレート仕様
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

### Current Implemented Directory Structure

```
Oshi-Trainer/
├── Oshi_TrainerApp.swift                  # ✅ アプリケーションエントリーポイント
├── ContentView.swift                       # （初期テンプレート、未使用）
├── Features/                               # ✅ 機能別モジュール（実装済み）
│   ├── Home/                              # ✅ ホーム画面（ウマ娘風UI）
│   │   ├── Views/
│   │   │   └── HomeView.swift            # ✅ メインホーム画面
│   │   └── ViewModels/
│   │       └── HomeViewModel.swift       # ✅ ホーム画面ロジック
│   ├── LevelDetail/                       # ✅ レベル詳細画面
│   │   ├── Views/
│   │   │   └── LevelDetailView.swift    # ✅ レベル・実績詳細表示
│   │   └── ViewModels/
│   │       └── LevelDetailViewModel.swift # ✅ レベル詳細ロジック
│   ├── Statistics/                        # ✅ 統計機能
│   │   ├── Views/
│   │   │   └── StatisticsView.swift     # ✅ 統計表示画面
│   │   └── ViewModels/
│   │       └── StatisticsViewModel.swift # ✅ 統計計算ロジック
│   ├── TrainerCreation/                   # ✅ 推しトレーナー作成
│   │   └── Views/
│   │       └── TrainerCreationView.swift # ✅ トレーナー作成画面
│   ├── Training/                          # ✅ トレーニング機能（UI部分）
│   │   └── Views/
│   │       ├── CameraView.swift          # ✅ カメラビュー
│   │       └── TrainingPopupView.swift   # ✅ トレーニング開始ポップアップ
│   └── Settings/                          # ✅ 設定画面
│       └── Views/
│           └── SettingsView.swift        # ✅ 設定画面
├── Models/                                 # ✅ データモデル（実装済み）
│   ├── OshiTrainer.swift                  # ✅ 推しトレーナーモデル
│   ├── DefaultOshiTrainerData.swift       # ✅ デフォルトトレーナー「推乃 愛」データ定義
│   ├── OshiTrainerTemplate.swift          # ✅ 推しトレーナーテンプレートモデル
│   ├── PersonalityType.swift              # ✅ 性格タイプ（優しい、元気、クール、ツンデレ、厳しい）
│   ├── EncouragementStyle.swift           # ✅ 応援スタイル（熱血、冷静、自然、過保護）
│   ├── FeedbackFrequency.swift            # ✅ フィードバック頻度（最小限、適度、頻繁、常時）
│   ├── Achievement.swift                  # ✅ 実績モデル
│   ├── Statistics.swift                   # ✅ 統計データモデル
│   └── TrainingSession.swift              # ✅ トレーニングセッションモデル
├── Services/                               # ✅ サービス層（実装済み）
│   ├── DataServiceProtocol.swift          # ✅ データアクセスプロトコル
│   ├── MockDataService.swift              # ✅ 開発用モックサービス
│   ├── DialogueTemplateProvider.swift     # ✅ テンプレートセリフ提供サービス
│   └── Audio/                             # ✅ 音声フィードバックサービス
│       ├── AudioFeedbackServiceProtocol.swift  # ✅ 音声フィードバックプロトコル
│       └── AudioFeedbackService.swift     # ✅ AVAudioPlayerベースの音声再生実装
├── Shared/                                 # ✅ 共有コンポーネント（実装済み）
│   ├── Extensions/
│   │   └── Color+Oshi.swift              # ✅ ウマ娘風カラーパレット
│   ├── Styles/
│   │   ├── OshiButtonStyle.swift         # ✅ カスタムボタンスタイル
│   │   └── OshiTextStyles.swift          # ✅ カスタムテキストスタイル
│   ├── Utilities/
│   │   └── AlphaHitTestImageView.swift   # ✅ アルファ値ベースのタップ判定
│   └── Views/
│       └── TransparentImageView.swift    # ✅ 背景透過画像表示ビュー
└── Assets.xcassets/                       # ✅ アセットカタログ
    ├── AppIcon.appiconset/                # アプリアイコン
    ├── AccentColor.colorset/              # アクセントカラー
    ├── Oshino-Ai.imageset/                # ✅ デフォルト推しトレーナー画像
    └── Contents.json                      # アセットメタデータ
```

### 今後実装予定の構造
```
Oshi-Trainer/
├── Core/                                   # コア機能（今後実装）
│   ├── Vision/                            # 姿勢推定・カメラ処理
│   │   ├── PoseEstimator.swift           # 姿勢推定エンジン
│   │   ├── CameraManager.swift           # カメラ管理
│   │   └── Models/                        # Core MLモデル
│   ├── AI/                                # AI/LLM統合
│   │   ├── LLMService.swift              # LLM API クライアント
│   │   └── PersonalityEngine.swift       # パーソナリティ生成
│   └── Data/                              # データ永続化
│       ├── CoreDataStack.swift           # Core Data管理
│       └── UserDefaultsManager.swift     # 設定管理
└── Resources/
    └── MLModels/                          # Core MLモデルファイル
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

## Audio Assets Structure

### Zundamon Voice System

```
audio/
└── ずんだもん/                 # ずんだもん音声アセット（48ファイル）
    ├── rep_count/             # レップカウント音声（40ファイル）
    │   ├── zunda_rep_1.wav   # 「1回なのだ！」
    │   ├── zunda_rep_2.wav   # 「2回なのだ！」
    │   └── ... (zunda_rep_40.wavまで)
    ├── timer/                 # タイマー音声（5ファイル）
    │   ├── zunda_start.wav    # トレーニング開始音声
    │   ├── zunda_5_seconds.wav   # 残り5秒警告
    │   ├── zunda_10_seconds.wav  # 残り10秒警告
    │   ├── zunda_30_seconds.wav  # 残り30秒通知
    │   └── zunda_complete.wav    # トレーニング完了音声
    ├── form_error/            # フォームエラー音声（1ファイル）
    │   └── zunda_elbow-error.wav  # 肘開きエラー警告
    └── speed/                 # 速度フィードバック音声（2ファイル）
        ├── zunda_too-fast.wav     # 速すぎる警告
        └── zunda_too-slow.wav     # 遅すぎる警告
```

### Audio Integration Strategy
- **iOS統合**: `AVAudioPlayer`または`AVFoundation`で再生
- **Bundle Management**: Xcodeビルド時に`Assets.xcassets`またはBundleリソースとして含める
- **File Naming Convention**: `zunda_[category]_[identifier].wav`
- **Playback Queue**: 複数音声の順次再生管理

## Reference Programs Structure（参考プログラム）

### Purpose and Usage
リアルタイムフォーム解析機能の実装に向けた参考実装コード集

### Directory Organization

```
参考プログラム/
├── CameraManager.swift           # カメラセッション管理の参考実装
├── MLModelManager.swift          # Core ML推論管理の参考実装
└── ExerciseTrainingView.swift   # トレーニング画面UIの参考実装
```

### File Descriptions

#### CameraManager.swift
**Role**: AVFoundationベースのカメラセッション管理の実装例
- カメラ権限の要求と状態管理（`AVAuthorizationStatus`）
- フロント/バックカメラの切り替え（`AVCaptureDevice.Position`）
- リアルタイムピクセルバッファ出力（`CVPixelBuffer`）
- デリゲートパターンでのフレーム配信（`CameraOutputDelegate`）
- リソースクリーンアップ管理（`ResourceCleanupCoordinator`）
- セッション制御の安全な実装（DispatchQueue活用）

**Integration Target**: `realtime-form-analysis`仕様の`CameraService.swift`

#### MLModelManager.swift
**Role**: Core MLモデル推論管理の実装例
- Core MLモデルの非同期推論実行（async/await）
- バッチ処理とパフォーマンス最適化
- エラーハンドリングとフォールバック処理
- リソース管理とメモリ効率化

**Integration Target**: `realtime-form-analysis`仕様の`PoseEstimationService.swift`

#### ExerciseTrainingView.swift
**Role**: トレーニング画面UIの構成例
- カメラプレビューとML推論結果のオーバーレイ表示
- リアルタイムフィードバックUI
- SwiftUI + UIViewRepresentable連携パターン
- リアルタイムデータバインディング

**Integration Target**: `realtime-form-analysis`仕様の`TrainingView.swift`

### Development Workflow
1. **参考実装の確認**: 各ファイルの実装パターンを理解
2. **仕様への適用**: `realtime-form-analysis`仕様のタスク実装時に参考
3. **段階的統合**: 参考実装をベースに、仕様に沿った実装を行う

## Python Prototype Structure

### Proof-of-Concept: Pose Estimation System

```
python/
├── main_overheadpress.py       # オーバーヘッドプレス解析スクリプト
├── convert_models.py           # YOLOモデルのCore ML変換ユーティリティ
├── yolo11n-pose.pt             # YOLOv11 Poseモデル（6.2MB）
└── .venv/                      # Python仮想環境（依存関係インストール済み）
```

**注**: Pythonプロトタイプの音声機能は、iOS用の`audio/ずんだもん/`アセットに移行済み

### Prototype Features
- **リアルタイム姿勢推定**: YOLOv11でキーポイント検出
- **ルールベースフォーム解析**: エクササイズ固有のエラー判定ロジック
- **レップカウント**: キーポイント位置/角度による動作カウント
- **速度判定**: フレーム数ベースの速度チェック（早すぎる/遅すぎる）
- **音声フィードバック**: pygameによる音声再生

### Current Implementation

#### オーバーヘッドプレス（`main_overheadpress.py`）
- **キーポイント**: 肩、肘、手首
- **エラー検出**: 肘の開きエラー（肩幅正規化）
- **カウント方式**: 肘角度の閾値判定
- **音声**: ずんだもん音声フィードバック（48音声ファイル）

### iOS統合への移行計画
1. **YOLOモデルのCore ML変換**: `yolo11n-pose.pt` → `.mlmodel`
2. **Vision Frameworkとの統合**: 姿勢推定ロジックのSwift実装
3. **AVFoundationカメラ統合**: リアルタイムビデオ処理
4. **音声フィードバック**: AVAudioPlayerまたはSpeech Synthesis
5. **推しキャラクターとの統合**: フィードバックを推しのセリフとして表示
6. **エクササイズ拡張性**: 新しいエクササイズを追加できる設計

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
