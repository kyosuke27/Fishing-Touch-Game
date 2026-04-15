//
//  UserGameDataRepository.swift
//  Fising-Touch-Game
//
//  Created by Codex on 2026/04/16.
//

import Foundation

protocol UserGameDataRepositoryProtocol {
    func load() throws -> UserGameData
    func save(_ data: UserGameData) throws
}

final class UserGameDataRepository: UserGameDataRepositoryProtocol {
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func load() throws -> UserGameData {
        let url = try dataURL()
        guard fileManager.fileExists(atPath: url.path) else {
            let initial = GameMaster.initialData
            try save(initial)
            return initial
        }

        let data = try Data(contentsOf: url)
        return try decoder.decode(UserGameData.self, from: data)
    }

    func save(_ data: UserGameData) throws {
        let url = try dataURL()
        let encoded = try encoder.encode(data)
        try encoded.write(to: url, options: .atomic)
    }

    /// Documents配下の永続化パスを1箇所にまとめる。
    private func dataURL() throws -> URL {
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw CocoaError(.fileNoSuchFile)
        }
        return documentsURL.appendingPathComponent("user_game_data.json")
    }
}
