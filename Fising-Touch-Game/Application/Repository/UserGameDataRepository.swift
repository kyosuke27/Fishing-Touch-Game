import Foundation

/// ユーザーデータの永続化を抽象化するリポジトリ。
protocol UserGameDataRepository {
    /// 永続化済みのユーザーデータを読み込む。
    /// - Returns: 読み込んだユーザーデータ。
    func load() throws -> UserGameData

    /// ユーザーデータを保存する。
    /// - Parameter data: 保存対象のユーザーデータ。
    func save(_ data: UserGameData) throws
}
