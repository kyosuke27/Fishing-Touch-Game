# spec.md — お手軽フィッシング

## 概要
- iOS向けのシンプルなカジュアル釣りゲーム
- 左右に動くバーをヒットゾーン内で止めて魚を釣る
- 魚図鑑、釣果履歴、コイン、餌切り替えで継続性を作る
- 技術構成は Swift / SwiftUI / FileManager / JSON保存
- 認証なし、バックエンドなし、オフライン前提

## MVPスコープ
### 実装するもの
- ホーム画面
- 釣り画面
- 釣果結果画面
- 魚図鑑画面
- 魚詳細画面
- 釣果一覧画面
- ショップ / 餌選択画面
- 海ステージ1種類
- 魚3種
- コイン付与
- 餌切り替え
- 図鑑登録
- 釣果履歴保存
- FileManagerによるJSON保存

### 実装しないもの
- ログイン
- クラウド同期
- 課金
- 広告
- 昼夜切り替え
- 複数ステージ
- 釣竿成長
- バイブレーション
- 通知
- ソーシャル機能

## コアゲーム仕様
### プレイフロー
1. ホームで「釣りを始める」を押す
2. 現在の餌に応じて魚を抽選する
3. 釣り画面でバーが左右移動する
4. プレイヤーが「タップ」ボタンを押す
5. ヒットゾーン内なら成功、外なら失敗
6. 必要ヒット回数を連続成功すると釣り成功
7. 結果画面で魚、重量、コイン、図鑑登録結果を表示する

### 判定ルール
- タップ位置がヒットゾーン内なら成功
- ヒットゾーン外なら失敗
- 失敗した時点でその挑戦は終了
- 必要ヒット回数は連続成功でのみ加算する

### 難易度調整
- レア度が高いほどヒットゾーンを狭くする
- 重量が重いほどバー速度を速くする
- 必要ヒット回数が多いほど難しくする

## 魚マスタ
### メダカ
- id: medaka
- rarity: 1
- requiredHits: 1
- hitZoneWidth: 0.30
- barSpeed: 1.8
- minWeight: 0.1
- maxWeight: 0.3
- rewardCoin: 50
- description: 初心者向けの小さな魚

### アジ
- id: aji
- rarity: 2
- requiredHits: 3
- hitZoneWidth: 0.20
- barSpeed: 1.3
- minWeight: 0.3
- maxWeight: 1.0
- rewardCoin: 100
- description: バランスのよい基準魚

### タイ
- id: tai
- rarity: 3
- requiredHits: 5
- hitZoneWidth: 0.12
- barSpeed: 0.95
- minWeight: 2.0
- maxWeight: 5.0
- rewardCoin: 150
- description: レア感と達成感を演出する目玉魚

## 餌仕様
### 通常餌
- id: normal_bait
- name: アオイソメ
- price: 0
- 効果: 補正なし
- 初期選択: true

### 高級餌
- id: premium_bait
- name: エビ
- price: 1500
- 効果: レア魚出現率アップ

### 出現率例
#### 通常餌
- メダカ: 50
- アジ: 35
- タイ: 15

#### 高級餌
- メダカ: 25
- アジ: 40
- タイ: 35

## 画面仕様
### 1. ホーム画面
#### 目的
- アプリの入口
- 釣り開始導線を最優先で見せる

#### 要素
- タイトル「お手軽フィッシング」
- 所持コイン表示
- 現在選択中の餌表示
- 「釣りを始める」
- 「魚図鑑」
- 「釣果一覧」
- 「ショップ」

### 2. 釣り画面
#### 目的
- バー停止ゲームに集中させる

#### 要素
- 海背景
- 所持コイン
- 現在の餌
- ヒット回数表示
- 現在成功数表示
- 動くバー
- ヒットゾーン
- 大きな「タップ」ボタン

### 3. 釣果結果画面
#### 成功時要素
- 「釣れた！」
- 魚イラスト
- 魚名
- レア度
- 重量
- 獲得コイン
- NEW または 図鑑登録済み
- 「もう一度釣る」
- 「ホームへ戻る」

#### 失敗時要素
- 「逃げられた…」
- 「もう一度釣る」
- 「ホームへ戻る」

### 4. 魚図鑑画面
- タイトル「魚図鑑」
- 達成率表示
- 発見済み魚カード
- 未発見魚カード
- 戻るボタン
- 発見済み魚タップで魚詳細へ遷移

### 5. 魚詳細画面
- 戻るボタン
- 魚イラスト
- 魚名
- レア度
- 説明文
- 最大記録重量
- 釣った回数

### 6. 釣果一覧画面
- タイトル「釣果一覧」
- 戻るボタン
- 新しい順の釣果リスト
- 各セルに魚アイコン、魚名、重量、レア度、日時、獲得コイン

### 7. ショップ / 餌選択画面
- タイトル「ショップ」
- 戻るボタン
- 所持コイン
- 餌カード一覧
- 餌名
- 説明文
- 価格
- 状態表示
- 購入ボタン / 選択ボタン

## 画面遷移
```text
ホーム
 ├─ 釣り画面
 │   └─ 結果画面
 │       ├─ もう一度釣る -> 釣り画面
 │       └─ ホームへ戻る -> ホーム
 ├─ 魚図鑑
 │   └─ 魚詳細
 ├─ 釣果一覧
 └─ ショップ / 餌選択
```

## データモデル
### FishMaster
```swift
struct FishMaster: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let rarity: Int
    let description: String
    let requiredHits: Int
    let hitZoneWidth: Double
    let barSpeed: Double
    let minWeight: Double
    let maxWeight: Double
    let rewardCoin: Int
    let assetName: String
}
```

### BaitMaster
```swift
struct BaitMaster: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let price: Int
    let rarityWeights: [String: Int]
    let assetName: String
}
```

### CaughtFish
```swift
struct CaughtFish: Codable, Identifiable, Hashable {
    let id: String
    let fishId: String
    let fishName: String
    let rarity: Int
    let weight: Double
    let rewardCoin: Int
    let caughtAt: Date
}
```

### EncyclopediaEntry
```swift
struct EncyclopediaEntry: Codable, Identifiable, Hashable {
    let id: String
    let fishId: String
    var isUnlocked: Bool
    var caughtCount: Int
    var maxWeight: Double?
    var firstCaughtAt: Date?
}
```

### UserGameData
```swift
struct UserGameData: Codable {
    var coin: Int
    var selectedBaitId: String
    var ownedBaitIds: [String]
    var catchHistory: [CaughtFish]
    var encyclopedia: [EncyclopediaEntry]
}
```

## 保存仕様
- 保存先: Documents/user_game_data.json
- 保存タイミング
  - 魚を釣った直後
  - 餌を購入した直後
  - 餌を切り替えた直後
- アプリ起動時にロード
- JSONが存在しなければ初期データ生成

## 状態管理
### 推奨構成
- AppGameStore
- FishingViewModel
- HomeViewModel
- EncyclopediaViewModel
- ShopViewModel

### AppGameStoreの責務
- UserGameData保持
- ロード / セーブ
- コイン加算 / 減算
- 図鑑更新
- 餌購入
- 餌切り替え

### FishingViewModelの責務
- 魚抽選
- バー状態管理
- ヒット判定
- 成功数管理
- 結果状態管理

## UIルール
### テーマカラー
- メイン: RGB(58, 145, 255)
- サブ: RGB(88, 200, 176)
- アクセント: RGB(255, 196, 79)
- 背景: RGB(241, 248, 255)
- カード: RGB(255, 255, 255)
- 主文字: RGB(34, 58, 94)
- 補助文字: RGB(109, 128, 150)
- 警告: RGB(244, 96, 96)

### トーン
- 明るい
- 親しみやすい
- 軽快
- 海辺の爽やかさ
- iOSらしい
- 標準コンポーネント8割、カスタム2割

## 参考UIデザイン
- 同階層のいかに画面に対応する画像を用意しているのでそれを参考にしてデザインを作成してください。
- 画像を参照する際に以下のルールに沿ってください
    -　画像内でSwiftコードで作るのではなく、画像として読み込んで表示するものはそれを見越してコーディングしてください。（例：ロゴ部分の画像を使うので、コンポーネントには画像を渡して表示するようにする）
- 1. ホーム画面
    - Home.PNG
- 2. 釣り画面
    - Fishing.PNG
- 3. 釣果結果画面
    - Result.PNG
-  4. 魚図鑑画面
    - FishList.PNG
-  5. 魚詳細画面
    - FishDetail.PNG
-  6. 釣果一覧画面
    - FishingResult.PNG
-  7. ショップ / 餌選択画面
    - Shop.PNG

## アーキテクト
- クリーンアーキテクチャ
    - Presentation
        - View,ViewModel
    - Domain
    - Infrastructure
    - Application
- 関数やコードにはコメントをつけて説明を入れるように

## 実装タスク例
1. プロジェクト作成
2. カラーテーマ定義
3. データモデル定義
4. FileManager保存基盤
5. ホーム画面
6. 釣り画面
7. 結果画面
8. 図鑑 / 詳細
9. 釣果一覧
10. ショップ
11. テストと調整

## 受け入れ条件
- ホームから釣りを開始できる
- 魚3種が抽選される
- バーをタップで判定できる
- 必要ヒット回数で成功 / 失敗が分かれる
- 結果画面が正しく表示される
- コインが加算される
- 図鑑が更新される
- 釣果一覧に履歴が残る
- 餌を購入 / 選択できる
- 再起動後もデータが保持される

## 将来拡張
- 池 / 川ステージ
- 昼夜切り替え
- 魚種類追加
- 報酬広告
- バイブレーション
- 課金
- 餌消費型
- 釣竿成長
- デイリーミッション
- 限定魚イベント
