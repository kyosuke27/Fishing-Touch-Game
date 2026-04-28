import Foundation

/// `UserGameDataRepository` のファイル保存実装。
final class UserGameDataRepositoryImpl: UserGameDataRepository {
    /// ファイル操作に使用するFileManager。
    private let fileManager: FileManager
    /// 保存時に使うエンコーダ。
    private let encoder: JSONEncoder
    /// 読み込み時に使うデコーダ。
    private let decoder: JSONDecoder

    /// リポジトリを生成する。
    /// - Parameter fileManager: 利用するFileManager。
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    /// 永続化済みのユーザーデータを読み込む。
    /// - Returns: 読み込んだユーザーデータ。
    func load() throws -> UserGameData {
        let url = try dataURL()
        guard fileManager.fileExists(atPath: url.path) else {
            let initialData = GameMaster.initialData
            try save(initialData)
            return initialData
        }

        let data = try Data(contentsOf: url)
        return try decoder.decode(UserGameData.self, from: data)
    }

    /// ユーザーデータを保存する。
    /// - Parameter data: 保存対象のユーザーデータ。
    func save(_ data: UserGameData) throws {
        let url = try dataURL()
        let encodedData = try encoder.encode(data)
        try encodedData.write(to: url, options: .atomic)
    }

    /// 保存先URLを返す。
    /// - Returns: 保存先URL。
    private func dataURL() throws -> URL {
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw CocoaError(.fileNoSuchFile)
        }
        return documentsURL.appendingPathComponent("user_game_data.json")
    }
}
