import Foundation

/// ユーザーデータ読み込み処理のインターフェース。
protocol LoadUserGameDataUseCase {
    /// ユーザーデータを取得する。
    /// - Returns: 読み込んだユーザーデータ。
    func execute() throws -> UserGameData
}

/// ユーザーデータ読み込み処理の実装。
struct LoadUserGameDataUseCaseImpl: LoadUserGameDataUseCase {
    /// 読み込み先リポジトリ。
    private let repository: UserGameDataRepository

    /// UseCaseを生成する。
    /// - Parameter repository: 利用するリポジトリ。
    init(repository: UserGameDataRepository) {
        self.repository = repository
    }

    /// ユーザーデータを取得する。
    /// - Returns: 読み込んだユーザーデータ。
    func execute() throws -> UserGameData {
        try repository.load()
    }
}
