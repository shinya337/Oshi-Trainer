# Technology Stack - Oshi-Trainer

**Inclusion Mode**: Always

## Architecture

### Application Type
- **Platform**: iOS Native Application
- **UI Framework**: SwiftUI
- **Architecture Pattern**: MVVM (推奨)
- **Development Environment**: Xcode 26.0, iOS 26
- **Minimum Deployment Target**: iOS 26

### Design Patterns
- **SwiftUI Declarative UI**: 宣言的UIによる状態管理とビュー構築
- **Combine Framework**: リアクティブプログラミングとデータフロー管理（今後活用予定）
- **Protocol-Oriented Programming**: Swiftのプロトコル指向設計
  - **実装例**: `DataServiceProtocol` - データアクセス層の抽象化
  - テスタビリティとモック実装の容易性を提供

### AI & Machine Learning

#### iOS (計画中)
- **Vision Framework**: カメラベースの姿勢推定とリアルタイムフォーム解析
- **Core ML**: オンデバイス機械学習モデルの実行
- **AVFoundation**: カメラキャプチャとビデオ処理
- **LLM Integration** (Future): 推しトレーナーのパーソナリティ生成とセリフ生成
- **Speech Synthesis** (Future): 推しの声によるフィードバック

#### Pythonプロトタイプ（実験中）
**技術スタック**:
- **YOLO Pose Estimation**: YOLOv11n-poseモデル（`yolo11n-pose.pt`, 6.2MB）
- **OpenCV**: リアルタイムビデオ処理とカメラキャプチャ
- **Ultralytics**: YOLOモデル推論エンジン
- **NumPy**: 数値計算とキーポイント解析
- **pygame**: 音声フィードバック再生
- **Collections (deque)**: スムージング用の履歴管理

**実装済みエクササイズ**:
- **オーバーヘッドプレス**（`main_overheadpress.py`）:
  - ルールベース判定: 肘の開きエラー（肩幅正規化）、速度判定、角度ベースレップカウント
  - ずんだもん音声フィードバック（48音声ファイル使用）
  - キーポイント: 肩、肘、手首

**モデル変換ツール**:
- **convert_models.py**: YOLOモデルをCore ML形式に変換するユーティリティ
  - iOS統合のためのモデル変換スクリプト
  - CoreMLTools活用

## Frontend

### Core Technologies
- **Language**: Swift 6.x
- **UI Framework**: SwiftUI
- **Navigation**: NavigationStack
- **State Management**: @State, @Binding, @ObservableObject, @EnvironmentObject

### UI Components
- **Native SwiftUI Views**: Text, Image, VStack, HStack, NavigationStack, etc.
- **SF Symbols**: システムアイコンライブラリ
- **Custom Components**: プロジェクト固有のカスタムビューコンポーネント
- **Implemented Custom Components**:
  - `OshiButtonStyle`: ウマ娘風のボタンスタイル（Primary, Secondary, Icon）
  - `OshiTextStyles`: カスタムテキストスタイル（タイトル、数字表示など）
  - `Color+Oshi`: ウマ娘風カラーパレット拡張
    - `oshiBackground`, `oshiBackgroundSecondary`
    - `oshiGreen`, `oshiTextPrimary`, `oshiTextSecondary`など
  - `TransparentImageView`: 背景透過PNG画像の表示用カスタムビュー
  - `AlphaHitTestImageView`: アルファ値ベースのタップ領域判定を実装したUIImageView

## Data & Storage

### Local Storage Options
- **UserDefaults**: 設定や小規模データの永続化
- **Core Data**: 構造化データの永続化（今後実装予定）
- **FileManager**: ファイルベースのデータ管理

### Data Service Layer
- **DataServiceProtocol**: データアクセスの抽象化レイヤー
  - `getOshiTrainer()`: 推しトレーナーデータの取得
  - `getLevelData()`: レベル、経験値、実績データの取得
  - `getStatistics()`: 統計データの取得
- **MockDataService**: 開発用モックデータサービス（`DataServiceProtocol`の実装）
  - UI開発時のダミーデータ提供
  - 実際のデータ永続化実装前の開発を可能にする
  - デフォルト推しトレーナー「推乃 愛」のデータ提供
- **DialogueTemplateProvider**: テンプレートセリフ提供サービス
  - ツンデレ性格のセリフテンプレート管理
  - カテゴリー別セリフ取得（挨拶、トレーニング開始、応援、照れ隠し）
  - 将来的なLLM統合への移行を考慮した設計

### Audio Feedback Service
- **AudioFeedbackServiceProtocol**: 音声フィードバック機能の抽象化
- **AudioFeedbackService**: ずんだもん音声フィードバックの実装
  - **AVAudioPlayerベース**: キュー管理方式の音声再生
  - **レップカウント**: `playRepCount(_ count: Int)` - 1〜40回のカウント音声
  - **タイマーアラート**: `playTimerAlert(_ secondsRemaining: Int)` - 5/10/30秒警告、完了通知
  - **フォームエラー**: `playFormError(_ errorType: FormErrorType)` - 肘開きエラー等の警告
  - **速度フィードバック**: `playSpeedFeedback(_ speedType: SpeedType)` - 早すぎる/遅すぎる警告
  - **キュー式再生**: 複数音声の順次再生管理（AVAudioPlayerDelegate）
  - **リソース管理**: Bundle内のWAVファイルへのアクセス管理

### Data Models
- **Swift Structs/Classes**: データモデルの定義
- **Codable Protocol**: JSON エンコード/デコード（今後のサーバー連携用）
- **実装済みモデル**:
  - `OshiTrainer`: 推しトレーナーのデータモデル（名前、レベル、経験値、画像、セリフ）
  - `DefaultOshiTrainerData`: デフォルト推しトレーナー「推乃 愛」のデータ定義
  - `OshiTrainerTemplate`: 推しトレーナーテンプレートモデル
    - 基本プロフィール（名前、テーマカラー、キャラクター画像）
    - 性格・口調パラメータ（一人称、二人称、性格説明）
    - LLM統合パラメータ（プロンプト指示、参考口調、禁止ワード）
    - 音声・ボイスパラメータ（CV、音声スタイル）
    - トレーニング設定（応援スタイル、フィードバック頻度、リアルタイム対応）
  - `PersonalityType`: 性格タイプ（優しい、元気、クール、ツンデレ、厳しい）
  - `EncouragementStyle`: 応援スタイル（熱血、冷静、自然、過保護）
  - `FeedbackFrequency`: フィードバック頻度（最小限、適度、頻繁、常時）
  - `Achievement`: 実績・アチーブメントモデル
  - `Statistics`: 統計データモデル（`MonthlyStatistic`, `CategoryStatistic`）
  - `TrainingSession`: トレーニングセッション記録モデル

### Audio Assets
- **Voice System**: 96音声ファイル（2キャラクター対応）

  **ずんだもん音声システム**（48ファイル）:
  - **Rep Count Audio**: レップカウント音声（`zunda_rep_1.wav`〜`zunda_rep_40.wav`、40ファイル）
  - **Timer Audio**: タイマー音声（`zunda_start.wav`, `zunda_5_seconds.wav`, `zunda_10_seconds.wav`, `zunda_30_seconds.wav`, `zunda_complete.wav`、5ファイル）
  - **Form Error Audio**: フォームエラー音声（`zunda_elbow-error.wav`、1ファイル）
  - **Speed Audio**: 速度フィードバック音声（`zunda_too-fast.wav`, `zunda_too-slow.wav`、2ファイル）

  **四国めたん音声システム**（48ファイル）:
  - **Rep Count Audio**: レップカウント音声（`shikoku_rep_1.wav`〜`shikoku_rep_40.wav`、40ファイル）
  - **Timer Audio**: タイマー音声（`shikoku_start.wav`, `shikoku_5_seconds.wav`, `shikoku_10_seconds.wav`, `shikoku_30_seconds.wav`, `shikoku_complete.wav`、5ファイル）
  - **Form Error Audio**: フォームエラー音声（`shikoku_elbow-error.wav`、1ファイル）
  - **Speed Audio**: 速度フィードバック音声（`shikoku_too-fast.wav`, `shikoku_too-slow.wav`、2ファイル）

  - **Format**: WAV形式（iOS上でAVFoundationで再生）
  - **Location**:
    - ソースファイル: `audio/ずんだもん/`, `audio/四国めたん/`
    - iOS統合: `Resources/Audio/ずんだもん/`, `Resources/Audio/四国めたん/`
  - **Usage**: リアルタイムフォーム解析機能の音声フィードバック、キャラクター別音声選択

## Development Environment

### Required Tools
- **Xcode**: 26.0（最新バージョン）
- **macOS**: 最新バージョン
- **iOS Simulator**: iOS 26対応
- **Git**: バージョン管理

### Optional Tools
- **SF Symbols App**: アイコン選択用
- **Instruments**: パフォーマンス分析
- **Physical iOS Device**: 実機テスト

## Common Commands

### Python Prototype
```bash
# Pythonプロトタイプの実行（カメラ必須）
cd python

# オーバーヘッドプレス解析
python main_overheadpress.py

# 依存関係インストール（初回のみ）
pip install ultralytics opencv-python numpy pygame

# 終了: 'q'キーを押す
```

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
  - `Oshi_TrainerTests.swift`: 基本ユニットテスト
  - `DefaultOshiTrainerDataTests.swift`: デフォルトトレーナーデータのテスト
  - `DialogueTemplateProviderTests.swift`: セリフテンプレートサービスのテスト
  - `HomeViewModelTests.swift`: ホーム画面ViewModelのテスト
  - `MockDataServiceTests.swift`: モックデータサービスのテスト
  - `OshiTrainerTemplateTests.swift`: テンプレートモデルのテスト
  - `OshiTrainerTemplateIntegrationTests.swift`: テンプレート統合テスト
  - `PersonalityTypeTests.swift`: 性格タイプのテスト
  - `TrainingParametersTests.swift`: トレーニングパラメータのテスト
  - `ColorOshiThemeTests.swift`: カラーテーマのテスト
  - `Oshi_TrainerUITests.swift`: UIテスト
  - `Oshi_TrainerUITestsLaunchTests.swift`: 起動テスト

### Testing Best Practices
- ビジネスロジックのユニットテスト
- UI要素の統合テスト
- TDD（Test-Driven Development）の推奨
- テンプレートシステムの包括的テストカバレッジ

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

### iOS Dependencies
現在、iOSアプリでは外部依存関係は使用していません。必要に応じて以下のツールで管理：

- **Swift Package Manager (SPM)**: 推奨
  - Vision/Core ML関連の追加ライブラリ
  - ネットワーキングライブラリ（Alamofire等）
  - JSON処理ライブラリ
- **CocoaPods**: 代替オプション
- **Carthage**: 代替オプション

#### Planned iOS Dependencies
- **Pose Estimation Models**: Core ML形式の姿勢推定モデル
- **Networking**: APIクライアント（LLM統合用）
- **Calendar Integration**: Google Calendar SDK
- **Analytics** (Optional): ユーザー行動分析

### Python Prototype Dependencies
Pythonプロトタイプで使用中のライブラリ：

```python
# 主要な依存関係
ultralytics      # YOLOv11 Pose推論エンジン
opencv-python    # ビデオ処理とカメラキャプチャ
numpy            # 数値計算
pygame           # 音声再生
```

**依存関係管理**: `requirements.txt`またはPipenvで管理可能（現在は未設定）
