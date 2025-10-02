# Requirements Document

## Introduction

デフォルト推しトレーナー「推乃 愛（オシノ アイ）」は、推しトレーナー作成機能が実装されるまでの間、ホーム画面に表示されるデフォルトのキャラクターです。この機能により、ユーザーは初回起動時からすぐにアプリの世界観を体験でき、ツンデレキャラクターとの交流を通じてモチベーションを得られます。

既存の`OshiTrainer`モデルと`MockDataService`を活用し、デフォルトトレーナーのデータを提供することで、将来的なカスタムトレーナー作成機能へのスムーズな移行を可能にします。

## Requirements

### Requirement 1: デフォルト推しトレーナーのキャラクター定義
**Objective:** アプリユーザーとして、ツンデレな性格を持つデフォルトの推しトレーナー「推乃 愛（オシノ アイ）」と出会い、初回起動から魅力的なキャラクターと一緒にトレーニングを始められるようにしたい。

#### Acceptance Criteria

1. WHEN アプリケーションが起動される THEN Oshi-Trainerアプリ SHALL デフォルト推しトレーナー「推乃 愛（オシノ アイ）」のデータを読み込む
2. WHEN デフォルト推しトレーナーのデータが読み込まれる THEN Oshi-Trainerアプリ SHALL 名前「推乃 愛」を表示する
3. WHEN デフォルト推しトレーナーのデータが読み込まれる THEN Oshi-Trainerアプリ SHALL 一人称「うち」を性格設定として保持する
4. WHEN デフォルト推しトレーナーのデータが読み込まれる THEN Oshi-Trainerアプリ SHALL 二人称「あんた」を性格設定として保持する
5. WHEN デフォルト推しトレーナーのデータが読み込まれる THEN Oshi-Trainerアプリ SHALL ツンデレ性格（五等分の花嫁の二乃のような性格）を性格設定として保持する

### Requirement 2: デフォルト推しトレーナーの画像表示
**Objective:** アプリユーザーとして、ホーム画面でデフォルト推しトレーナーの魅力的なビジュアルを見て、キャラクターへの親近感を感じたい。

#### Acceptance Criteria

1. WHEN ホーム画面が表示される THEN Oshi-Trainerアプリ SHALL デフォルト推しトレーナーのキャラクター画像を画面中央下部から生えるように配置する
2. WHEN キャラクター画像が表示される THEN Oshi-Trainerアプリ SHALL 背景透過済みの推し画像を使用する
3. WHEN キャラクター画像が表示される THEN Oshi-Trainerアプリ SHALL ウマ娘風UIデザインに調和した配置とスタイリングを適用する
4. WHEN ユーザーがキャラクター画像をタップする THEN Oshi-Trainerアプリ SHALL トレーニング開始ポップアップを表示する
5. WHEN キャラクター画像のタップ判定が処理される THEN Oshi-Trainerアプリ SHALL 透過部分（アルファ値が低い領域）をタップ不可能にする
6. WHEN キャラクター画像のタップ判定が処理される THEN Oshi-Trainerアプリ SHALL 不透明なキャラクター部分のみをタップ可能な領域として扱う

### Requirement 3: デフォルト推しトレーナーのメッセージ表示
**Objective:** アプリユーザーとして、デフォルト推しトレーナー「推乃 愛」からのメッセージを見て、キャラクターの性格を感じながらモチベーションを得たい。

#### Acceptance Criteria

1. WHEN ホーム画面が表示される THEN Oshi-Trainerアプリ SHALL デフォルト推しトレーナーの名前「推乃 愛」をメッセージエリアに表示する
2. WHEN ホーム画面が表示される THEN Oshi-Trainerアプリ SHALL デフォルト推しトレーナーのセリフをメッセージエリアに表示する
3. WHEN メッセージが表示される THEN Oshi-Trainerアプリ SHALL ウマ娘風の吹き出しスタイル（角丸長方形、影付き）でメッセージを表示する
4. WHEN メッセージテキストが表示される THEN Oshi-Trainerアプリ SHALL テンプレートセリフを使用する（将来的にLLMで性格に合わせた動的生成予定）

### Requirement 4: テンプレートセリフの定義
**Objective:** アプリユーザーとして、デフォルト推しトレーナーのツンデレな性格が表現されたセリフを読んで、キャラクターの個性を感じたい。

#### Acceptance Criteria

1. WHEN デフォルト推しトレーナーのセリフが生成される THEN Oshi-Trainerアプリ SHALL ツンデレ性格を反映したテンプレートセリフを使用する
2. WHEN テンプレートセリフが選択される THEN Oshi-Trainerアプリ SHALL 一人称「うち」を含むセリフを優先的に使用する
3. WHEN テンプレートセリフが選択される THEN Oshi-Trainerアプリ SHALL 二人称「あんた」を含むセリフを優先的に使用する
4. WHEN セリフが表示される THEN Oshi-Trainerアプリ SHALL トレーニング促進、応援、照れ隠しなど、状況に応じた複数のセリフパターンを提供する

### Requirement 5: データサービスとの統合
**Objective:** 開発者として、既存の`MockDataService`を活用してデフォルト推しトレーナーのデータを提供し、将来的なカスタムトレーナー機能への移行を容易にしたい。

#### Acceptance Criteria

1. WHEN `MockDataService.getOshiTrainer()`が呼び出される THEN MockDataService SHALL デフォルト推しトレーナー「推乃 愛」のデータを返す
2. WHEN デフォルト推しトレーナーのデータが返される THEN MockDataService SHALL `OshiTrainer`モデルの形式でデータを提供する
3. WHEN デフォルト推しトレーナーのデータが提供される THEN MockDataService SHALL 名前、レベル、経験値、画像名、セリフを含む完全なデータを返す
4. WHEN 推しトレーナー作成機能が将来実装される THEN Oshi-Trainerアプリ SHALL デフォルトトレーナーからカスタムトレーナーへスムーズに移行できる

### Requirement 6: ホーム画面での統合表示
**Objective:** アプリユーザーとして、ホーム画面でデフォルト推しトレーナー「推乃 愛」のビジュアル、名前、セリフが調和して表示され、一貫した体験を得たい。

#### Acceptance Criteria

1. WHEN ホーム画面が表示される THEN Oshi-Trainerアプリ SHALL キャラクター画像、名前、セリフを同時に表示する
2. WHEN ホーム画面の要素が配置される THEN Oshi-Trainerアプリ SHALL ウマ娘風UIデザインガイドラインに従ったレイアウトを使用する
3. WHEN ユーザーがホーム画面を操作する THEN Oshi-Trainerアプリ SHALL キャラクター画像とメッセージ表示の相互作用を適切に処理する
4. WHERE ユーザーが推し作成機能を持たない初期段階で THE Oshi-Trainerアプリ SHALL デフォルトトレーナー「推乃 愛」のみを表示する

## Non-Functional Requirements

### パフォーマンス
- デフォルト推しトレーナーのデータ読み込みは100ms以内に完了すること
- キャラクター画像の表示は滑らかで、アニメーション遅延がないこと

### 拡張性
- 将来的なLLM統合によるセリフ動的生成への移行を考慮した設計であること
- カスタムトレーナー作成機能実装時に、データモデルの変更を最小限に抑えられること

### UI/UX
- ウマ娘風のデザイン言語を一貫して使用すること
- キャラクターの性格（ツンデレ）がビジュアルとテキストの両方で表現されること
