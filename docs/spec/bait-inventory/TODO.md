# 餌購入・所持数管理 TODO

## 完了タスク

- `BaitMaster` に `rarity` と `imageName` を追加した。
- `GameMaster.baits` を 6 種構成へ更新した。
- 各餌に価格、レア度、画像名、抽選重みを設定した。
- 初期データの餌所持情報を `baitQuantities` ベースへ変更した。
- `UserGameData` に `baitQuantities` を追加した。
- 餌管理を `ownedBaitIds` から `baitQuantities` へ切り替えた。
- `PurchaseBaitUseCase` を「未所持解放」ではなく「購入ごとに 1 個加算」へ変更した。
- `SelectBaitUseCase` を「所持数が 1 以上なら選択可能」へ変更した。
- `GameSessionStore` に餌所持数取得処理 `baitCount(baitId:)` を追加した。
- `GameSessionStore.isOwned(baitId:)` を所持数判定ベースへ変更した。
- `HomeScreen` の選択中餌画像をマスタの `imageName` 参照へ変更した。
- `FishingScreen` の選択中餌画像をマスタの `imageName` 参照へ変更した。
- `ShopScreen` で餌画像をアセット画像表示へ変更した。
- `ShopScreen` で餌レア度表示を追加した。
- `ShopScreen` で餌所持数表示を追加した。
- `ShopScreen` で選択中でも追加購入できる UI に変更した。
- `Localizable.xcstrings` に `shop.stock` を追加した。
- 仕様書として `docs/spec/bait-inventory/spec.md` を追加した。

## 確認タスク

- ショップ画面で各餌画像が正しく表示されることを確認する。
- 餌購入時に所持コインが減算され、所持数が 1 増えることを確認する。
- 所持数 0 の餌は選択できず、所持数 1 以上の餌は選択できることを確認する。
- 選択中の餌画像がホーム画面と釣り画面に正しく反映されることを確認する。
- アオイソメ購入時に 0 コインのまま所持数だけ増える挙動が仕様通りかを確認する。

## 今後の検討

- 釣り実行時に餌を消費する仕様を追加するか検討する。
- 餌ごとの抽選重みをゲームバランスに合わせて再調整する。
- ショップカードの情報量が多い場合はレイアウト圧縮を検討する。
