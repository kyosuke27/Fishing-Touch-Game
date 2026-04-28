# task.md

## 2026-04-16
- `spec.md`をもとに、SwiftUIでMVP全体を実装しました。
- `AppGameStore`を追加し、コイン管理、餌購入/選択、図鑑更新、釣果登録、JSON永続化を管理するようにしました。
- `UserGameDataRepository`を追加し、`Documents/user_game_data.json`へ保存/読込する基盤を実装しました。
- 魚3種、餌2種、釣果/図鑑/ユーザーデータのモデルとマスタ定義を追加しました。
- ホーム、釣り、結果、魚図鑑、魚詳細、釣果一覧、ショップ画面を実装しました。
- 釣り画面では、左右に移動するバー、ヒットゾーン判定、連続成功数カウント、成功/失敗結果表示を実装しました。
- 釣果成功時にコイン加算、図鑑解放/更新、履歴保存が行われるようにしました。
- 単体テストとして、餌購入、釣果登録、餌選択のテストを追加しました。
- `xcodebuild -scheme Fising-Touch-Game -project Fising-Touch-Game.xcodeproj -destination 'generic/platform=iOS' -derivedDataPath /tmp/FisingTouchDerived CODE_SIGNING_ALLOWED=NO build` でビルド成功を確認しました。
- `xcodebuild test` はシミュレータ実行がこの環境で完走せず、現時点では結果を確定できていません。
