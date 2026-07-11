# ツリゲータッチ

> 「ツリゲータッチ」は、Greeやモバゲー時代の懐かしいガラケー釣りゲームの空気感を、スマホ向けに再構成したiOSアプリです。  
> タップ操作で魚を釣り、釣果・図鑑・餌選びを楽しめる、シンプルで遊びやすいカジュアル釣りゲームを目指しています。

---

## 目次

- [アプリ概要](#アプリ概要)
- [制作背景](#制作背景)
- [主な機能](#主な機能)
- [画面構成](#画面構成)
- [技術スタック](#技術スタック)
- [ディレクトリ構成](#ディレクトリ構成)
- [設計方針](#設計方針)
- [工夫したポイント](#工夫したポイント)
- [関連ドキュメント](#関連ドキュメント)
- [今後の改善予定](#今後の改善予定)
- [セットアップ方法](#セットアップ方法)

---

## アプリ概要

### アプリ名

ツリゲータッチ

### 一言でいうと

懐かしいモバイル釣りゲームの雰囲気をスマホで楽しめる、タップ操作型のiOS釣りゲームです。

### 対象ユーザー

- ガラケー時代のソーシャルゲームに懐かしさを感じる人
- 短時間で遊べるカジュアルゲームが好きな人
- 図鑑埋めや収集要素を楽しみたい人

### 解決したい課題

- 昔のガラケーアプリのような、軽く遊べて少しずつ進める体験をスマホで再現する
- 複雑な操作ではなく、直感的なタップ操作で釣りの成功体験を得られるようにする
- 魚図鑑、釣果履歴、餌選択を通じて、短いプレイでも継続する楽しさを作る

---

## 制作背景

モバゲーの懐かしいガラケーアプリを、現代のスマホアプリとして作ってみたかったことが制作のきっかけです。  
当時の釣りゲームにあった「少しずつ魚を集める楽しさ」「レアな魚が釣れたときの嬉しさ」「簡単な操作で何度も遊べる手軽さ」を求めて開発しました。

このアプリでは、懐かしさを感じられる見た目や遊び心を残しつつ、SwiftUIによる画面構築、MVIパターン、Clean Architectureを意識した責務分離を取り入れています。

---

## 主な機能

- 釣りミニゲーム: タイミングに合わせてタップし、魚を釣り上げる
- 魚図鑑: 釣った魚の解放状況、最大重量、釣った回数を確認する
- 釣果履歴: 過去に釣った魚の記録を一覧で確認する
- 餌ショップ: コインを使って餌を購入し、狙える魚の傾向を変える
- 餌消費: 釣り開始時に選択中の餌を1個消費し、餌がない場合はショップへ誘導する
- コイン報酬: 釣った魚に応じてコインを獲得する
- レアリティ管理: 魚や餌ごとにレアリティを持たせ、収集の楽しさを作る
- 広告表示: Google Mobile Ads SDKを利用したバナー広告とインタースティシャル広告の土台を実装
- 画像アセット: ホーム背景、ボタン、魚、餌、コイン、ヒットバーなどの画像をAssets.xcassetsで管理

### 実装した機能

- ホーム画面
- 釣り画面
- リザルト表示
- 魚図鑑
- 釣果履歴
- 餌購入・餌選択
- 餌所持数管理・餌消費
- JSONファイルによるローカル保存
- AdMobバナー広告
- 確率制御付きインタースティシャル広告
- 日本語・英語の多言語化リソース

### 現在のマスタデータ

- 魚: 11種
  - メダカ、フナ、どじょう、キス、アジ、イサキ、スズキ、タイ、カンパチ、マグロ、さめ
- 餌: 6種
  - アオイソメ、えび、オキアミ、キビナゴ、アジ、イカの切り身

### 今後追加したい機能

- 釣り場の追加
- 季節・時間帯による出現魚の変化
- 魚ごとの演出強化
- 実績・ミッション機能
- サウンド・振動フィードバック
- 広告同意管理や本番広告ID運用の整備

---

## 画面構成

### ホーム画面

コイン、選択中の餌、図鑑進捗を表示し、釣り・図鑑・釣果履歴・ショップへ遷移する起点画面です。

### 釣り画面

ヒットバーとタップボタンを使って、タイミングよく魚を釣る画面です。魚ごとに必要タップ回数や判定幅、バー速度が変わります。

### リザルト画面

釣り結果、獲得コイン、新種判定、新記録判定を表示します。

### 魚図鑑画面

魚の解放状況、レアリティ、説明、最大重量などを確認する画面です。

### 釣果履歴画面

釣った魚の履歴を新しい順に確認する画面です。

### ショップ画面

餌の購入と選択を行う画面です。餌ごとに価格やレアリティ、狙いやすい魚の傾向が異なります。

---

## 技術スタック

| 項目             | 内容                                 |
| ---------------- | ------------------------------------ |
| 言語             | Swift                                |
| UI               | SwiftUI                              |
| アーキテクチャ   | MVI / Clean Architecture             |
| 状態管理         | ViewModel / State / ObservableObject |
| 永続化           | FileManager / JSON                   |
| 多言語化         | Localizable.xcstrings                |
| 広告             | Google Mobile Ads SDK                |
| プライバシー     | AppTrackingTransparency              |
| テスト           | XCTest / XCUITest                    |
| 対応OS           | iOS 17.0以上                         |
| アプリバージョン | 1.1.0                                |
| 開発環境         | Xcode                                |

### 採用理由

- SwiftUI: 状態とUIの関係を宣言的に扱いやすく、画面実装を簡潔に保てるため
- MVI: Viewからの入力、状態更新、画面反映の流れを明確にするため
- Clean Architecture: Presentation、Application、Domain、Infrastructureの責務を分離し、変更に強い構成にするため
- FileManager / JSON: ユーザーデータを`Documents/user_game_data.json`として保存し、データ構造を確認しやすくするため
- Localizable.xcstrings: 日本語と英語の多言語化を前提に、画面文言をコードから分離するため
- Google Mobile Ads SDK: バナー広告とインタースティシャル広告の表示基盤をSwiftUIへ組み込むため

### Swift Package Manager

`Package.resolved`で以下のパッケージを固定しています。

- Google Mobile Ads SDK: `swift-package-manager-google-mobile-ads` 13.3.0
- Google User Messaging Platform: `swift-package-manager-google-user-messaging-platform` 3.1.0

---

## ディレクトリ構成

```text
Fising-Touch-Game/
├── Application/
│   ├── Repository/
│   └── UseCase/
├── Domain/
│   └── Entity/
├── Infrastructure/
│   └── Repository/
├── Presentation/
│   ├── Feature/
│   │   ├── CatchHistory/
│   │   ├── Encyclopedia/
│   │   ├── Fishing/
│   │   ├── Home/
│   │   └── Shop/
│   └── Shared/
│       ├── Admob/
│       ├── Components/
│       ├── Model/
│       └── Theme/
├── Assets.xcassets/
├── Localizable.xcstrings
└── Fising_Touch_GameApp.swift
```

### 各ディレクトリの役割

- Application: UseCaseとRepositoryのインターフェースを配置する層
- Domain: 魚、餌、釣果、ユーザーデータなどのEntityを配置する層
- Infrastructure: Repositoryの実装や永続化など、技術詳細を扱う層
- Presentation: SwiftUIのScreen、ViewModel、State、Componentを配置する層
- Presentation/Shared: 複数画面で利用する共通Model、Component、Themeを配置する層
- Presentation/Shared/Admob: AdMobバナー広告とインタースティシャル広告の表示・ロード処理を配置する層
- Assets.xcassets/img: 魚、餌、ホーム背景、ボタン、コイン、ヒットバーなどの画像素材を配置する領域

---

## 設計方針

### アーキテクチャ

MVIパターンとClean Architectureを組み合わせ、UI、状態、ユースケース、データ保存の責務を分離しています。

### 状態管理

- Screen: ViewModelのStateを購読し、画面表示とユーザー操作を担当する
- ViewModel: ユーザー操作を受け取り、UseCaseを呼び出してStateを更新する
- State: 画面に必要な表示状態を表現する
- UseCase: 釣果登録、餌購入、保存、読み込みなどのアプリケーションロジックを担当する
- Repository: データ保存方法を抽象化し、Infrastructure側の実装へ依存を閉じ込める

### 依存方向

PresentationからApplication、ApplicationからDomainへ依存する構成にし、Infrastructureの実装詳細が画面側へ漏れないようにしています。

---

## 工夫したポイント

### UI/UX

- 懐かしい釣りゲームらしさを出すため、魚、コイン、餌、ボタンなどを画像中心で表現
- 釣り開始、図鑑、履歴、ショップへすぐ移動できるホーム導線を用意
- タップ操作に絞り、短時間でも遊べるテンポを意識

### ゲーム設計

- 魚ごとに必要ヒット数、判定幅、バー速度、重量、報酬コインを設定
- 餌ごとに魚の出現重みを変え、餌選びに意味を持たせる
- 新種・新記録の判定を用意し、繰り返し遊ぶ動機を作る

### 保守性

- Screen、ViewModel、State、Componentを分割し、画面の肥大化を防止
- UseCaseを機能単位で分割し、テストしやすい粒度に整理
- 共通UIはPresentation/Shared/Componentsへ配置し、重複実装を避ける

---

## 関連ドキュメント

- `docs/spec/spec.md`: 初期MVP仕様
- `docs/spec/task.md`: 実装履歴とビルド確認メモ
- `docs/spec/bait-inventory/spec.md`: 餌所持数・餌消費仕様
- `docs/spec/admob-placement/spec.md`: AdMob配置仕様
- `docs/spec/image-asset-integration/spec.md`: 画像アセット統合仕様
- `docs/spec/fishing-hit-bar/spec.md`: ヒットバー仕様
- `docs/spec/result-overlay/spec.md`: リザルト表示仕様

---

## 今後の改善予定

- 釣り場ごとの魚出現テーブル追加
- 魚・餌マスタの外部データ化
- Unit Testの拡充
- UIテストによる主要導線の検証
- App Store公開に向けたアイコン、スクリーンショット、説明文の整備
- アクセシビリティ対応の強化
- Google User Messaging Platformを利用した広告同意フローの実装
- APIキーや広告IDの環境別設定手順の整備

---

## セットアップ方法

### 必要環境

- Xcode
- iOS Simulatorまたは実機
- Swift
- iOS 17.0以上
- Swift Package Managerで依存パッケージを解決できるネットワーク環境

### 起動方法

```bash
git clone https://github.com/your-name/Fising-Touch-Game.git
cd Fising-Touch-Game
open Fising-Touch-Game.xcodeproj
```

1. Xcodeで `Fising-Touch-Game.xcodeproj` を開く
2. 実行対象のSimulatorまたは実機を選択する
3. Swift Package Managerの依存解決が完了するまで待つ
4. 必要に応じてAdMob用のBuild Settingsまたはxcconfigで以下の値を設定する
   - `ADMOB_KEY`
   - `BANNER_KEY`
   - `INTER_KEY`
5. Runしてアプリを起動する

### ビルド確認例

```bash
xcodebuild \
  -scheme Fising-Touch-Game \
  -project Fising-Touch-Game.xcodeproj \
  -destination 'generic/platform=iOS' \
  -derivedDataPath /tmp/FisingTouchDerived \
  CODE_SIGNING_ALLOWED=NO \
  build
```

---

## README記入時の確認事項

- スクリーンショット画像を追加するか
- 正式なアプリ名をこのまま「ツリゲータッチ」にするか
- App Store公開予定の有無を記載するか
- 使用した画像素材やライセンス表記を追加するか
- AdMob本番ID、テストID、同意管理の運用方針をどこまで公開するか
