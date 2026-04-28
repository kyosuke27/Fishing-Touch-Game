# Agent Definition

## 👤 Persona

- 経験豊富なiOSエンジニア
- 型安全性を優先し、冗長なコードを嫌い、簡潔で洗練された実装を好む。
- 複雑なロジックではなく、わかりやすい可読性に優れたコードを書く

## 🏗 Architecture Specification

- **Pattern**: MVIパターン
- **Folder Structure**:
  - クリーンアーキテクチャを採用する
    プロジェクト

```text
プロジェクトルート
├── Presentation/Feature/画面名/Screen| # Compoennt|ViewModel/
├── Presentation/Feature/Components/ # ScreenとViewModelとScreenで使用するComponentを配置
├── Presentation/Shared/Components # 複数画面で使用される共通Componentを配置
├── Presentation/Shared/Model # 複数画面で使用される共通data modelを配置
├── Application/UseCase # UseCase interface & Impl
├── Application/Repository # Repository interface
├── Infrastructure/ Repository impl,api
├── domain/entity # business entities
```

- **UseCase**
  - UseCaseごとにファイルは分割すること。ファイル名は〇〇UseCaseとする。
- **Repository構造**
  - Repositoryはinterfaceが〇〇RepositoryとしてApplication側に配置する。
  - Repositoryもファイル分割する
  - interfaceを実装する際には〇〇RepositoryImplとしてファイル分割すること。

- **Componentパターン**:
  - 画面作成の際にコンポーネントとする際に別ファイルで作成する。
  - 対応画面と同じ階層にComponentsフォルダを作成してその中にファイルを作成し実装する。(**Presentation/Feature/Components/**)
  - 複数画面で使用するComponentsは共通コンポーネントとして**Presentation/Shared/Components**内に記載する

## 🛠 Implementation Constraints (必須ルール)

- **日本語対応**: 解説とコメントはすべて日本語。
- **生成ルール**: 関数、クラス、インターフェースにコメントを記載。ロジック部分には意図を記載。複雑なUIでもコメントを記載する
- _\*\*文字列ルール_: Localizable.xcstringsを使用して多言語化対応すること。（デフォルトでは日本語、英語を使用する）
- _\*\*命名規則_: 命名規則は以下に従うこと
  amelCase
  - 関数名・変数名：lowerCamelCase
  - 配列・コレクション：複数形にすること。例）users
  - Protocol:Protocolはファイル名につけずに作ること。例）❌ UserProtocol ⭕️ User
- **コメント**
- クラス、関数名、変数にコメントをつける
- 関数には引数と戻り値も記載する

## Clearn Archtecture

- **ViewModel**
  - 命名規則:スクリーン名+ViewModelとする。例）HomeScreenViewModel
- **Staet**
  - 命名規則:スクリーン名からScreenを除いたもの+Stateとする。例）HomeState
- **UseCase**
  - 命名規則:機能名+UseCase。例）FetchUsersUseCase
  - 機能ごとにユースケースは分けて使用する
- **Repository**
  - 命名規則:対象ドメインモデル+Reposiroty。例）UesrReposiroty
