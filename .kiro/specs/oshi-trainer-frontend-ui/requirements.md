# Requirements Document

## Introduction
本仕様は、Oshi-TrainerアプリケーションのフロントエンドUIの実装要件を定義します。ウマ娘のホーム画面をイメージしたユーザーインターフェースを構築し、推しトレーナーとのインタラクティブな体験を提供することが目的です。本フェーズではUIのみを実装し、バックエンドシステムやデータ永続化は対象外とします。

## Requirements

### Requirement 1: メイン画面（ホーム画面）の表示
**Objective:** ユーザーとして、ウマ娘風のホーム画面で推しトレーナーとのインタラクティブな体験を得たい。これにより、アプリを開いた瞬間から推し活とトレーニングのモチベーションを高めることができる。

#### Acceptance Criteria
1. WHEN アプリが起動される THEN Oshi-Trainerアプリ SHALL メイン画面を表示する
2. WHERE メイン画面の左上 THE Oshi-Trainerアプリ SHALL 推しレベルをテキスト表示する
3. WHERE メイン画面の右上 THE Oshi-Trainerアプリ SHALL 推し作成ボタンを表示する
4. WHERE メイン画面の中央 THE Oshi-Trainerアプリ SHALL 推しトレーナーのキャラ画像を表示する
5. WHERE キャラ画像の前面 THE Oshi-Trainerアプリ SHALL セリフ欄を表示する
6. WHERE メイン画面の左下 THE Oshi-Trainerアプリ SHALL 統計ボタンを表示する
7. WHERE メイン画面の右下 THE Oshi-Trainerアプリ SHALL 設定ボタンを表示する
8. WHEN メイン画面が表示される THEN Oshi-Trainerアプリ SHALL 全てのUI要素を適切なレイアウトで配置する

### Requirement 2: 推しレベル詳細の表示
**Objective:** ユーザーとして、自分の推しレベルや獲得した経験値、称号を確認したい。これにより、トレーニングによる成長を可視化し、さらなるモチベーション向上につなげることができる。

#### Acceptance Criteria
1. WHEN ユーザーが推しレベル表示をタップする THEN Oshi-Trainerアプリ SHALL 推しレベル詳細画面を表示する
2. WHERE 推しレベル詳細画面 THE Oshi-Trainerアプリ SHALL 現在の推しレベルを表示する
3. WHERE 推しレベル詳細画面 THE Oshi-Trainerアプリ SHALL 獲得した経験値の総量を表示する
4. WHERE 推しレベル詳細画面 THE Oshi-Trainerアプリ SHALL 獲得した称号のリストを表示する
5. WHEN ユーザーが推しレベル詳細画面を閉じる操作を行う THEN Oshi-Trainerアプリ SHALL メイン画面に戻る

### Requirement 3: 推しトレーナー作成画面への遷移
**Objective:** ユーザーとして、自分好みの推しトレーナーを作成できる画面にアクセスしたい。これにより、パーソナライズされたトレーニング体験を構築できる。

#### Acceptance Criteria
1. WHEN ユーザーが推し作成ボタンをタップする THEN Oshi-Trainerアプリ SHALL 推しトレーナー作成画面に遷移する
2. WHERE 推しトレーナー作成画面 THE Oshi-Trainerアプリ SHALL トレーナーカスタマイズのためのUI要素を表示する
3. WHEN ユーザーが作成画面を閉じる操作を行う THEN Oshi-Trainerアプリ SHALL メイン画面に戻る

### Requirement 4: トレーニング開始フロー
**Objective:** ユーザーとして、推しトレーナー画像をタップしてトレーニングを開始したい。これにより、直感的な操作でトレーニングセッションを始めることができる。

#### Acceptance Criteria
1. WHEN ユーザーが推しトレーナー画像をタップする THEN Oshi-Trainerアプリ SHALL トレーニングポップアップを表示する
2. WHERE トレーニングポップアップ THE Oshi-Trainerアプリ SHALL トレーニング種目の説明を表示する
3. WHERE トレーニングポップアップ THE Oshi-Trainerアプリ SHALL トレーニングの推奨時間を表示する
4. WHERE トレーニングポップアップ THE Oshi-Trainerアプリ SHALL トレーニング開始ボタンを表示する
5. WHEN ユーザーがトレーニング開始ボタンをタップする THEN Oshi-Trainerアプリ SHALL デバイスの内カメラを起動する
6. WHEN ユーザーがポップアップを閉じる操作を行う THEN Oshi-Trainerアプリ SHALL メイン画面に戻る

### Requirement 5: 統計画面の表示
**Objective:** ユーザーとして、自分のトレーニング統計を月ごとや種目ごとに確認したい。これにより、自分の成長を振り返り、継続的なモチベーション向上につなげることができる。

#### Acceptance Criteria
1. WHEN ユーザーが統計ボタンをタップする THEN Oshi-Trainerアプリ SHALL 統計画面を表示する
2. WHERE 統計画面 THE Oshi-Trainerアプリ SHALL 月ごとのトレーニング統計を表示する
3. WHERE 統計画面 THE Oshi-Trainerアプリ SHALL 種目ごとのトレーニング統計を表示する
4. WHERE 統計画面 THE Oshi-Trainerアプリ SHALL 統計データを視覚的に表現する（グラフ、チャートなど）
5. WHEN ユーザーが統計画面を閉じる操作を行う THEN Oshi-Trainerアプリ SHALL メイン画面に戻る

### Requirement 6: 設定画面の表示
**Objective:** ユーザーとして、アプリの設定を確認・変更したい。これにより、アプリを自分の好みに合わせてカスタマイズできる。

#### Acceptance Criteria
1. WHEN ユーザーが設定ボタンをタップする THEN Oshi-Trainerアプリ SHALL 設定画面を表示する
2. WHERE 設定画面 THE Oshi-Trainerアプリ SHALL アプリ設定項目を表示する
3. WHERE 設定画面 THE Oshi-Trainerアプリ SHALL クレジット情報を表示する
4. WHERE 設定画面 THE Oshi-Trainerアプリ SHALL その他のアプリ情報を表示する
5. WHEN ユーザーが設定画面を閉じる操作を行う THEN Oshi-Trainerアプリ SHALL メイン画面に戻る

### Requirement 7: UI/UXデザインの一貫性
**Objective:** ユーザーとして、ウマ娘風の統一感のあるデザインで快適にアプリを利用したい。これにより、視覚的な魅力とユーザビリティを両立させる。

#### Acceptance Criteria
1. WHERE 全ての画面 THE Oshi-Trainerアプリ SHALL SwiftUIを使用して実装する
2. WHERE 全ての画面 THE Oshi-Trainerアプリ SHALL ウマ娘風のデザインテーマを適用する
3. WHERE 全てのインタラクティブ要素 THE Oshi-Trainerアプリ SHALL タップフィードバックを提供する
4. WHERE 全ての画面遷移 THE Oshi-Trainerアプリ SHALL スムーズなアニメーションを適用する
5. WHERE 全てのUI要素 THE Oshi-Trainerアプリ SHALL iOSのネイティブUIガイドラインに準拠する
