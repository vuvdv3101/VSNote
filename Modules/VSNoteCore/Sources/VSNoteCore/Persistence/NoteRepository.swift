//
//  NoteRepository.swift
//  VSNoteCore
//
//  Created by Admin on 6/2/26.
//

import Foundation
import GRDB

public protocol NoteRepository {
    func getAll() async throws -> [Note]
    func save(_ note: Note) async throws
    func delete(_ note: Note) async throws
    func update(_ note: Note) async throws
    func search(keyword: String) async throws -> [Note]
    func searchFullText(_ query: String) async throws -> [Note]
    func getSearchSuggestions(_ prefix: String) async throws -> [String]
    func syncToCloud() async throws
}

public final class SQLRepositoryImpl: NoteRepository {
    private let db: DatabasePool
    
    public init(db: DatabasePool) {
        self.db = db
    }
    
    public func getAll() async throws -> [Note] {
        try await db.read { db in
            try Note.order(Column("updatedAt").desc).fetchAll(db)
        }
    }
    
    public func save(_ note: Note) async throws {
        try await db.write { db in
            var note = note
            note.updatedAt = Date().timeIntervalSince1970
            try note.insert(db)
        }
    }
    
    public func delete(_ note: Note) async throws {
        return try await db.write { db in
            try Note.deleteOne(db, key: note.id)
        }
    }
    
    public func update(_ note: Note) async throws {
        try await db.write { db in
            var updatedNote = note
            updatedNote.updatedAt = Date().timeIntervalSince1970
            try updatedNote.update(db)
        }
    }
    
    public func search(keyword: String) async throws -> [Note] {
        let searchQuery = keyword.split(separator: " ").joined(separator: " AND ")
        
        return try await db.read { db in
            let sql = """
                SELECT note.* FROM note
                JOIN note_fts ON note.id = note_fts.rowid
                WHERE note_fts MATCH ?
                ORDER BY rank
            """
            return try Note.fetchAll(db, sql: sql, arguments: [searchQuery])
        }
    }
    
    public func searchFullText(_ query: String) async throws -> [Note] {
        let searchQuery = query.split(separator: " ").joined(separator: " AND ")
        return try await db.read { db in
            let sql = """
                SELECT note.* FROM note
                JOIN note_fts ON note.id = note_fts.rowid
                WHERE note_fts MATCH ?
                ORDER BY rank
                LIMIT 100
            """
            return try Note.fetchAll(db, sql: sql, arguments: [searchQuery])
        }
    }
    
    public func getSearchSuggestions(_ prefix: String) async throws -> [String] {
        try await db.read { db in
            let sql = """
                SELECT DISTINCT title FROM note_fts
                WHERE title LIKE ?
                LIMIT 10
            """
            return try String.fetchAll(db, sql: sql, arguments: ["\(prefix)%"])
        }
    }
    
    public func syncToCloud() async throws {
        // TODO: Implement cloud sync
        print("Cloud sync not implemented yet")
    }
}

public enum RepositoryError: Error {
    case invalidNote
    case databaseError(Error)
    case searchFailed
}
