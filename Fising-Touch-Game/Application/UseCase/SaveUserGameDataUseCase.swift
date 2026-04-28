import Foundation

/// ユーザーデータ保存処理のインターフェース。
protocol SaveUserGameDataUseCase {
    /// ユーザーデータを保存する。
    /// - Parameter data: 保存対象のユーザーデータ。
    func execute(data: UserGameData) throws
}

/// ユーザーデータ保存処理の実装。
struct SaveUserGameDataUseCaseImpl: SaveUserGameDataUseCase {
    /// 保存先リポジトリ。
    private let repository: UserGameDataRepository

    /// UseCaseを生成する。
    /// - Parameter repository: 利用するリポジトリ。
    init(repository: UserGameDataRepository) {
        self.repository = repository
    }

    /// ユーザーデータを保存する。
    /// - Parameter data: 保存対象のユーザーデータ。
    func execute(data: UserGameData) throws {
        try repository.save(data)
    }
}
