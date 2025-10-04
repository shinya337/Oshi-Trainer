# 実装計画

- [x] 1. プロジェクト基盤の構築とCapability設定
  - Xcodeプロジェクトに Communication Notifications Capability を追加
  - entitlementsファイルに `com.apple.developer.usernotifications.communication` キーを設定
  - App Group Capability を追加し、グループID `group.com.yourcompany.VirtualTrainer` を設定
  - メインアプリとExtensionの両方に同じApp Group IDを設定
  - プロビジョニングプロファイルの設定を確認
  - _Requirements: 1, 8_

- [x] 2. Notification Service Extensionターゲットの作成
  - Xcodeで新しい Notification Service Extension ターゲットを作成
  - `NotificationService.swift` と `Info.plist` が自動生成されることを確認
  - Extensionターゲットのビルド設定を確認（iOS 16.0+ Deployment Target）
  - Intents frameworkをインポート（`import Intents`）
  - _Requirements: 2_

- [x] 3. App Group共有ストレージの実装
- [x] 3.1 UserDefaultsDataServiceの拡張
  - App Group共有UserDefaults（`UserDefaults(suiteName:)`）をサポート
  - 選択中のトレーナーIDを共有UserDefaultsに保存する機能を追加
  - 全トレーナーテンプレートを共有UserDefaultsに保存する機能を追加
  - メインアプリ側でトレーナー選択時に共有UserDefaultsを更新
  - _Requirements: 8.3_

- [x] 3.2 ImagePersistenceServiceの拡張
  - App Groupコンテナのパスを取得する機能を追加
  - 画像をApp Group共有ディレクトリ（`TrainerImages/`）に保存する機能を実装
  - Notification Service ExtensionからApp Group共有ディレクトリの画像を読み込む機能を実装
  - 画像パス解決ロジックをApp Groupコンテナベースに変更
  - _Requirements: 6.1, 8.5_

- [x] 4. 通知データモデルとユーティリティの実装
- [x] 4.1 通知エラーモデルの定義
  - 通知権限拒否、スケジューリング失敗、トレーナーデータ不正、画像読み込み失敗などのエラータイプを定義
  - エラーハンドリング用のResultパターンを実装
  - _Requirements: 10_

- [x] 4.2 INPersonBuilderユーティリティの実装
  - OshiTrainerTemplateからINPersonオブジェクトを生成する機能を実装
  - トレーナー名を`displayName`、トレーナーIDを`personHandle`に設定
  - 画像ファイルパスからINImageを作成する機能を実装
  - 画像が存在しない場合は画像なしINPersonを返すフォールバック処理を実装
  - アクセシビリティラベル設定（「{トレーナー名}のプロフィール画像」）
  - _Requirements: 3, 12.3_

- [x] 4.3 INSendMessageIntentBuilderユーティリティの実装
  - INPersonとメッセージ本文からINSendMessageIntentを作成する機能を実装
  - 通知本文を`content`パラメータに設定
  - INPersonを`sender`パラメータに設定
  - トレーナーIDを`conversationIdentifier`に設定
  - `intent.setImage(_:forParameterNamed:)`を使用してINImageを明示的に設定
  - INInteractionを作成して`donateInteraction(for:)`を呼び出す機能を実装
  - _Requirements: 4_

- [x] 5. NotificationSchedulerサービスの実装
- [x] 5.1 通知スケジューリングのコアロジック
  - 通知スケジューリング用のプロトコル（`NotificationSchedulerProtocol`）を定義
  - 推しトレーナー、メッセージ、配信日時を受け取り通知をスケジュールする機能を実装
  - トレーナー情報をuserInfoディクショナリに追加（trainerId, notificationId, slotType, category）
  - `mutable-content=1`フラグを設定してNotification Service Extensionを有効化
  - UNNotificationRequestを作成してUNUserNotificationCenterに登録
  - _Requirements: 5.1_

- [x] 5.2 iOSバージョン別フォールバック処理
  - iOSバージョンを確認する機能を実装（iOS 15以上の判定）
  - iOS 15以上の場合はCommunication Notifications形式で通知を作成
  - iOS 14以下の場合はUNNotificationAttachmentベースの従来形式で通知を作成
  - iOSバージョンに応じて適切な通知形式を選択するロジックを実装
  - _Requirements: 7_

- [x] 5.3 通知管理機能
  - スケジュール済み通知を取得する機能を実装（`getPendingNotifications()`）
  - 通知をキャンセルする機能を実装（`cancelNotification(id:)`）
  - 全通知をキャンセルする機能を実装（`cancelAllNotifications()`）
  - _Requirements: 5_

- [x] 6. Notification Service Extensionの実装
- [x] 6.1 通知加工のエントリーポイント実装
  - `didReceive(_:withContentHandler:)`メソッドを実装
  - 通知リクエストのuserInfoからtrainerIDを取得
  - App Group共有UserDefaultsからトレーナー情報を読み込み
  - 元の通知コンテンツ（title、body）を保持
  - _Requirements: 4.1, 5.3_

- [x] 6.2 INPerson + INSendMessageIntent変換ロジック
  - INPersonBuilderを使用してトレーナー情報からINPersonオブジェクトを生成
  - App Group共有ディレクトリから画像を読み込み
  - INSendMessageIntentBuilderを使用してINSendMessageIntentを作成
  - INInteractionを作成して`donateInteraction(for:)`を呼び出し
  - 変換後の通知コンテンツをcontentHandlerで返す
  - _Requirements: 3, 4_

- [x] 6.3 エラーハンドリングとフォールバック処理
  - 画像読み込み失敗時は画像なしINPersonで通知配信を継続
  - トレーナーデータ取得失敗時はデフォルトトレーナー「推乃 愛」で代替
  - INSendMessageIntent作成失敗時は元の通知コンテンツで配信
  - 詳細なエラーログをOSLogで記録（エラーカテゴリ、失敗理由を含む）
  - タイムアウト時のフォールバック処理（`serviceExtensionTimeWillExpire()`）を実装
  - _Requirements: 6, 10_

- [x] 7. 通知カテゴリとユーザーインタラクションの維持
- [x] 7.1 通知カテゴリの設定
  - 既存の通知カテゴリ（`TRAINING_INVITATION`）を維持
  - 通知コンテンツに通知カテゴリを設定
  - _Requirements: 9.1_

- [ ] 7.2 AppDelegate通知ハンドラの統合
  - 通知タップ時のAppDelegate通知ハンドラ（`userNotificationCenter(_:didReceive:withCompletionHandler:)`）を実装
  - userInfoからトレーナーID、通知ID、時間帯タイプを取得
  - 既存のアナリティクス記録フローを実装（将来のNotificationAnalyticsService統合を考慮）
  - _Requirements: 9.2, 9.3, 5.4_

- [x] 8. デバッグとテスト機能の実装
- [x] 8.1 テスト通知送信機能
  - デバッグダッシュボードからテスト通知を送信する機能を実装
  - Notification Service Extensionを経由したCommunication Notifications形式の配信を確認
  - _Requirements: 10.1, 5.5_

- [x] 8.2 ロギングとモニタリング
  - OSLogを使用した詳細なエラーログ記録を実装
  - エラーカテゴリ別のログフォーマット（`[NotificationService] [エラーカテゴリ] メッセージ`）
  - 画像取得失敗、INSendMessageIntent作成失敗のログ記録
  - Extension実行時間のモニタリング（平均実行時間、タイムアウト率）
  - _Requirements: 10.2, 10.3, 10.4_

- [ ] 9. ユニットテストの実装
- [ ] 9.1 NotificationSchedulerのユニットテスト
  - 有効なトレーナーで通知スケジュールが成功することをテスト
  - 通知権限拒否時にエラーが返されることをテスト
  - 無効なトレーナーデータでエラーが返されることをテスト
  - 通知キャンセル機能のテスト
  - スケジュール済み通知取得機能のテスト
  - _Requirements: テスト戦略_

- [ ] 9.2 INPersonBuilderのユニットテスト
  - 有効なトレーナーからINPersonが作成されることをテスト
  - 画像なしトレーナーで画像なしINPersonが返されることをテスト
  - 有効な画像パスからINImageが作成されることをテスト
  - 無効な画像パスでnilが返されることをテスト
  - _Requirements: テスト戦略_

- [ ] 9.3 INSendMessageIntentBuilderのユニットテスト
  - 有効なパラメータでINSendMessageIntentが作成されることをテスト
  - donateInteractionメソッドが呼び出されることをテスト
  - _Requirements: テスト戦略_

- [ ] 10. 統合テストの実装
- [ ] 10.1 App Groupデータ共有の統合テスト
  - App Group UserDefaultsが正しくターゲット間でデータを共有することをテスト
  - ImagePersistenceServiceがApp Groupコンテナに保存・読み込みできることをテスト
  - Notification Service ExtensionがApp Groupからトレーナーデータを取得できることをテスト
  - _Requirements: テスト戦略_

- [ ] 10.2 通知配信フローのエンドツーエンドテスト
  - iOS 15以上でCommunication Notifications形式の通知が表示されることをテスト
  - iOS 14以下でUNNotificationAttachment形式の通知が表示されることをテスト（フォールバック）
  - 通知タップ時にAppDelegateハンドラが呼び出されることをテスト
  - _Requirements: テスト戦略_

- [ ] 11. パフォーマンステストの実装
- [ ] 11.1 Extension実行時間のパフォーマンステスト
  - Extension実行時間が30秒以内に完了することをテスト
  - 画像読み込みが1秒以内に完了することをテスト
  - INPersonオブジェクト作成が500ミリ秒以内に完了することをテスト
  - _Requirements: テスト戦略_

- [ ] 11.2 並行処理とメモリ使用量のテスト
  - 複数通知が並行して処理されることをテスト
  - 大量通知処理時にメモリ使用量が24MB制限内に収まることをテスト
  - _Requirements: テスト戦略_

- [ ] 12. 最終統合とドキュメント
- [ ] 12.1 HomeViewModelとの統合
  - HomeViewModelから通知スケジューリング機能を呼び出す統合を実装
  - 通知権限リクエストのUIフローを統合
  - _Requirements: 5_

- [ ] 12.2 アクセシビリティ検証
  - VoiceOverでの通知読み上げが正しく機能することを検証
  - ダイナミックタイプ設定での通知テキスト拡大表示を検証
  - 色覚異常モードでの通知表示を検証
  - _Requirements: 12_

- [ ] 12.3 将来拡張性の確保
  - カスタムトレーナー作成機能との互換性を確認
  - 異なる画像ディレクトリ構造への対応を確認
  - リモートURL画像対応の拡張ポイントを確認
  - _Requirements: 11_
