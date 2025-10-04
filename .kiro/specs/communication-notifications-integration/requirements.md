# 要件定義書

## はじめに

現在の推しトレーナーアプリの通知システムは、`UNNotificationAttachment`を使用してトレーナーの画像を添付していますが、画像は通知の右側に表示され、左上にはアプリアイコンが表示される従来の形式になっています。

ユーザーからの要望は「LINEのように左上に推しトレーナーの画像、その右下に小さくアプリアイコン」という表示形式です。調査の結果、iOS 15+の**Communication Notifications API**（`INPerson` + `INSendMessageIntent`）を使うことで実現可能と判明しました。LINEもこの同じAPIを使用しています。

本機能では、既存の通知システムを**Communication Notifications API**を使った実装に置き換えることで、通知センターで推しトレーナーの画像が左上に円形で表示され、メッセージアプリのような親密な視覚体験を提供します。

**ビジネス価値:**
- ユーザーとトレーナーの感情的絆を強化（「推しから連絡が来た」感の向上）
- 通知タップ率の向上（視覚的アイデンティティによる注目度向上）
- LINEなどの人気メッセージングアプリに近い親しみやすいUX
- 将来のカスタムトレーナー機能との親和性強化

## 要件

### 要件1: Communication Notifications Capabilityの有効化
**目的:** 開発者として、Xcodeプロジェクトに Communication Notifications Capability を追加することで、iOS通知システムがINSendMessageIntentを認識し、LINEライクな通知表示を有効化できるようにしたい

#### 受入基準

1. WHEN Xcodeプロジェクトの「Signing & Capabilities」タブで Communication Notifications Capability が追加される THEN システムは entitlementsファイルに `com.apple.developer.usernotifications.communication` キーを自動追加するものとする

2. WHEN アプリがビルドされる THEN システムは Communication Notificationsの使用許可を含むプロビジョニングプロファイルを要求するものとする

3. IF Communication Notifications Capability が正しく設定されていない場合 THEN システムは INSendMessageIntent を使用した通知送信時にエラーを返すものとする

### 要件2: Notification Service Extensionターゲットの作成
**目的:** 開発者として、Notification Service Extensionターゲットを新規作成することで、通知配信前に通知コンテンツを加工し、INSendMessageIntentに変換できるようにしたい

#### 受入基準

1. WHEN Xcodeで Notification Service Extension ターゲットが作成される THEN システムは `NotificationService.swift` ファイルと `Info.plist` を自動生成するものとする

2. WHEN NotificationService.swiftが生成される THEN システムは `didReceive(_:withContentHandler:)` メソッドを含む UNNotificationServiceExtension サブクラスを提供するものとする

3. WHEN Notification Service Extensionがビルドされる THEN システムはメインアプリとExtensionの両方を含むアプリバンドルを生成するものとする

4. WHEN 通知がデバイスに配信される THEN システムは Notification Service Extension を呼び出し、通知コンテンツの加工機会を提供するものとする

### 要件3: INPersonオブジェクトによる推しトレーナー表現
**目的:** ユーザーとして、通知センターで推しトレーナーの名前と画像が「送信者」として表示されることで、「推しから連絡が来た」という親密な体験を得たい

#### 受入基準

1. WHEN Notification Service Extension内で INPersonオブジェクトが作成される THEN システムは推しトレーナーの `displayName` を INPersonの `displayName` プロパティに設定するものとする

2. WHEN INPersonオブジェクトが作成される THEN システムは一意の識別子として推しトレーナーの `id` を `personHandle` プロパティに設定するものとする

3. WHEN 推しトレーナーの画像が利用可能な場合 THEN システムは `OshiTrainer.imageFileURL()` を使用して画像パスを取得し、INImageオブジェクトを作成して `image` プロパティに設定するものとする

4. IF 推しトレーナーの画像が存在しない場合 THEN システムは INPersonオブジェクトを画像なしで作成し、デフォルトのアバターが表示されるものとする

5. WHEN 複数のトレーナーが存在する場合 THEN システムは各トレーナーごとに独立した INPersonオブジェクトを作成し、通知送信者を視覚的に区別できるようにするものとする

### 要件4: INSendMessageIntentによる通知コンテンツの変換
**目的:** 開発者として、Notification Service Extension内でUNNotificationContentをINSendMessageIntentに変換することで、iOS通知システムがCommunication Notifications形式で表示できるようにしたい

#### 受入基準

1. WHEN Notification Service Extensionが通知を受信する THEN システムは元の通知コンテンツ（`content.title` と `content.body`）を保持するものとする

2. WHEN INSendMessageIntentが作成される THEN システムは通知本文（`content.body`）を INSendMessageIntentの `content` パラメータに設定するものとする

3. WHEN INSendMessageIntentが作成される THEN システムは前述のINPersonオブジェクトを `sender` パラメータに設定するものとする

4. WHEN INSendMessageIntentが作成される THEN システムは `conversationIdentifier` にトレーナーIDまたは通知カテゴリIDを設定し、通知のグループ化を可能にするものとする

5. WHEN INSendMessageIntentが設定される THEN システムは `intent.setImage(_:forParameterNamed:)` を使用してINImageを明示的に設定し、通知センターでの画像表示を保証するものとする

6. WHEN INSendMessageIntentがINInteractionに変換される THEN システムは `donateInteraction(for:)` を呼び出し、通知の配信をiOSに通知するものとする

7. WHEN 変換された通知コンテンツがコールバックで返される THEN システムは `contentHandler(newContent)` を呼び出し、iOS通知システムが変更後のコンテンツを表示するものとする

### 要件5: 既存の通知サービスとの統合
**目的:** ユーザーとして、既存の通知機能（メッセージパーソナライゼーション、時間帯設定、通知頻度管理、通知効果測定）を維持しながらCommunication Notifications APIを追加してほしい

#### 受入基準

1. WHEN 通知サービスが通知をスケジュールする THEN システムは既存の通知スケジューリングロジックを維持し、通知コンテンツにトレーナー情報を `userInfo` ディクショナリに追加するものとする

2. WHEN 通知がスケジュールされる THEN システムは既存のトレーナーメッセージ生成ロジックを変更せずに実行し、同じパーソナライズドメッセージを提供するものとする

3. WHEN Notification Service Extensionが通知を加工する THEN システムは `userInfo` からトレーナーIDを取得し、対応するトレーナー情報を取得するものとする

4. WHEN 通知効果測定機能が有効な場合 THEN システムは Communication Notifications形式の通知のタップ率を既存のアナリティクスフローで記録するものとする

5. WHEN デバッグモードのテスト通知が使用される THEN システムは同じ Communication Notificationsロジックを適用し、開発者が視覚的に検証できるようにするものとする

### 要件6: 画像リソース管理とフォールバック処理
**目的:** 開発者として、画像リソースが適切に管理され、画像取得失敗時も通知配信が継続されることを確認したい

#### 受入基準

1. WHEN Notification Service Extensionが画像を取得する THEN システムは既存の `OshiTrainer.imageFileURL()` メソッドを使用し、Bundle内の画像パスを取得するものとする

2. IF Bundle内の画像が見つからない場合 THEN システムは INPersonオブジェクトを画像なしで作成し、通知は名前とメッセージのみで配信されるものとする

3. WHEN 画像ファイルが取得される THEN システムは INImage初期化時に画像データを読み込み、INPersonオブジェクトに添付するものとする

4. IF INImage作成に失敗した場合 THEN システムはエラーログを記録し、画像なしINPersonオブジェクトで処理を継続するものとする

5. WHEN 画像がApp Groupコンテナに保存される場合 THEN システムは Notification Service ExtensionがApp Group経由で画像にアクセスできるよう共有ストレージを設定するものとする

### 要件7: iOSバージョンによるフォールバック処理
**目的:** プロダクトオーナーとして、iOS 15未満のデバイスでも通知が正常に配信されることを保証したい

#### 受入基準

1. WHEN アプリが起動する THEN システムはiOSバージョンを確認し、iOS 15以上の場合のみ Communication Notifications APIを有効化するものとする

2. IF デバイスのiOSバージョンが15未満の場合 THEN システムは既存のUNNotificationAttachmentベースの実装を使用し、従来の通知表示（右側に画像）を維持するものとする

3. WHEN 通知サービスが通知をスケジュールする THEN システムはiOSバージョンに基づいて適切な通知形式を選択するものとする

4. WHEN 通知が配信される THEN システムはiOS 15以上ではCommunication Notifications形式、iOS 14以下ではUNNotificationAttachment形式を使用するものとする

5. WHEN デバッグダッシュボードでテスト通知が送信される THEN システムは現在のデバイスのiOSバージョンに対応した通知形式を表示するものとする

### 要件8: App Group設定とデータ共有
**目的:** 開発者として、Notification Service Extensionがメインアプリのデータ（トレーナー設定、画像リソース）にアクセスできるようにしたい

#### 受入基準

1. WHEN App Groupがプロジェクトに追加される THEN システムは一意のグループID（例: `group.com.yourcompany.VirtualTrainer`）を設定するものとする

2. WHEN App Group Capabilityが有効化される THEN システムはメインアプリとNotification Service Extensionの両方に同じApp Group IDを設定するものとする

3. WHEN トレーナー設定がUserDefaultsを使用する THEN システムはApp Groupの共有UserDefaults（`UserDefaults(suiteName:)`）を使用し、選択中のトレーナー情報をExtensionと共有するものとする

4. WHEN Notification Service Extensionがトレーナー情報を取得する THEN システムは共有UserDefaultsから `selectedTrainerId` を読み取り、対応するトレーナーオブジェクトを取得するものとする

5. IF App Groupが正しく設定されていない場合 THEN システムは Notification Service Extension内でデフォルトのトレーナー情報を使用し、エラーログを記録するものとする

### 要件9: 通知カテゴリとユーザーインタラクションの維持
**目的:** ユーザーとして、通知をタップしたときに既存のアプリ起動・トレーニング開始フローが維持されることを期待する

#### 受入基準

1. WHEN 通知コンテンツが作成される THEN システムは既存の通知カテゴリ（`TRAINING_INVITATION`）を維持するものとする

2. WHEN ユーザーが通知をタップする THEN システムは既存のAppDelegate通知ハンドラを呼び出すものとする

3. WHEN 通知ハンドラが実行される THEN システムは通知の `userInfo` からトレーナーID、通知ID、時間帯タイプを取得し、既存のアナリティクス記録を実行するものとする

4. WHEN 通知がロック画面またはバナーで表示される THEN システムは既存のプライバシー設定（通知プレビュー設定）を尊重し、画像表示もユーザーの設定に従うものとする

5. WHEN ダークモード環境で通知が表示される THEN システムは通知センターのデフォルトレンダリングを使用し、画像が適切にコントラストを保つものとする

### 要件10: デバッグとトラブルシューティング
**目的:** 開発者として、Notification Service Extensionの動作を検証できるデバッグ機能を持ちたい

#### 受入基準

1. WHEN デバッグダッシュボードからテスト通知が送信される THEN システムは Notification Service Extensionを経由し、Communication Notifications形式で配信するものとする

2. WHEN Notification Service Extension内でエラーが発生する THEN システムは詳細なエラーログをコンソールに出力するものとする

3. WHEN 画像取得に失敗した場合 THEN システムはエラーログに失敗理由（ファイル未検出、読み込みエラー等）を含めるものとする

4. WHEN INSendMessageIntent作成に失敗した場合 THEN システムはフォールバックとして元の通知コンテンツを配信し、変換失敗をログに記録するものとする

5. WHEN 開発者がXcodeデバッガを使用する THEN システムは Notification Service Extensionプロセスにアタッチ可能であり、ブレークポイントとステップ実行をサポートするものとする

### 要件11: 将来のカスタムトレーナー拡張対応
**目的:** プロダクトオーナーとして、将来ユーザーが自由にトレーナーを作成・カスタマイズできるようになる際、このCommunication Notifications機能がシームレスに動作することを保証したい

#### 受入基準

1. WHEN 新しいカスタムトレーナーが追加される THEN システムは既存のINPerson作成ロジックを変更せずに動作するものとする

2. WHEN カスタムトレーナー画像が異なるディレクトリ構造で保存される THEN システムはトレーナーの画像ディレクトリプロパティを使用して柔軟にパスを解決するものとする

3. WHEN ユーザーが独自の画像をアップロードする場合 THEN システムはApp Groupコンテナ内の共有ディレクトリに保存し、Notification Service Extensionがアクセスできるようにするものとする

4. WHEN 複数のカスタムトレーナーが並行して通知を送信する THEN システムは各トレーナーごとに独立したINPersonオブジェクトを作成し、通知送信者を正確に表示するものとする

5. IF 将来的にトレーナー画像がリモートURL（API経由）で提供される場合 THEN システムは画像をダウンロード・キャッシュしてからINImage作成を行うよう拡張可能なアーキテクチャを維持するものとする

### 要件12: アクセシビリティとユーザーエクスペリエンス
**目的:** ユーザーとして、通知の視覚的改善がアクセシビリティを損なわず、VoiceOverユーザーや視覚障害を持つユーザーも同等の体験を得られることを期待する

#### 受入基準

1. WHEN 通知にINPersonが設定される THEN システムは `INPerson.displayName` にトレーナー名を設定し、VoiceOver読み上げで「{トレーナー名}からのメッセージ」と認識されるものとする

2. WHEN VoiceOverが有効な状態で通知が読み上げられる THEN システムは通知本文と送信者名の両方を読み上げ、画像の存在も音声で示すものとする

3. WHEN 通知画像が表示される THEN システムはINPersonの画像にアクセシビリティラベルを設定し、「{トレーナー名}のプロフィール画像」として認識されるようにするものとする

4. WHEN ダイナミックタイプ設定が大きいフォントサイズに設定されている THEN システムは通知テキストをシステム設定に従って拡大表示するものとする

5. WHEN 色覚異常モード（アクセシビリティ設定）が有効な場合 THEN システムは通知表示がシステムの色覚補正フィルタを適用し、視認性を維持するものとする

## 技術的制約

- **iOS対応バージョン**: iOS 16.0+をメインターゲットとし、iOS 15+でCommunication Notifications APIを使用
- **iOS 14以下**: UNNotificationAttachmentベースのフォールバック実装を維持
- **画像フォーマット**: PNG/JPEG形式、推奨サイズは正方形（例: 200x200px）
- **Notification Service Extension**: 最大実行時間30秒、メモリ制限24MB
- **App Group設定**: メインアプリとExtension間のデータ共有に必須
- **Intents framework**: `import Intents`が必要
- **既存のOshiTrainerモデルとの互換性維持**: `imageFileURL()`メソッドを活用

## 成功指標

- 通知センターで推しトレーナーの画像が左上に円形で表示される（iOS 15+）
- 推しトレーナーの名前が送信者として表示される
- アプリアイコンが右下に小さく表示される
- 通知タップ率（CTR）の向上（Communication Notifications形式 vs 従来形式比較）
- 通知効果測定による効果検証
- デバッグダッシュボードでのテスト通知で期待通りの表示
- VoiceOver利用時の適切な読み上げ動作
- iOS 14以下デバイスでのフォールバック動作の正常性
