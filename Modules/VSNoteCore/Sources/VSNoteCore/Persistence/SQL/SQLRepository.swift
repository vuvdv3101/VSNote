//
//  SQLRepositoryImpl.swift
//  VSNoteCore
//
//  Created by Admin on 8/2/26.
//

import Foundation
import GRDB

final class SQLRepository: NoteRepository {
    private let db: DatabasePool
    
    init(db: DatabasePool) {
        self.db = db
    }
    
    func getAll() async throws -> [Note] {
        try await db.read { db in
            try Note.order(Column("updatedAt").desc).fetchAll(db)
        }
    }
    
    func save(_ note: Note) async throws {
        try await db.write { db in
            var note = note
            note.updatedAt = Date().timeIntervalSince1970
            try note.save(db)
        }
    }
    
    func delete(_ noteId: Int64) async throws {
        return try await db.write { db in
            try Note.deleteOne(db, key: noteId)
        }
    }
    
    func update(_ note: Note) async throws {
        try await db.write { db in
            var updatedNote = note
            updatedNote.updatedAt = Date().timeIntervalSince1970
            try updatedNote.update(db)
        }
    }
    
    func search(keyword: String) async throws -> [Note] {
        let searchQuery = keyword.split(separator: " ").joined(separator: " AND ")
        
        return try await db.read { db in
            let sql = """
                SELECT notes.* FROM note
                JOIN note_fts ON note.id = note_fts.rowid
                WHERE note_fts MATCH ?
                ORDER BY rank
            """
            return try Note.fetchAll(db, sql: sql, arguments: [searchQuery])
        }
    }
    
    func searchFullText(_ query: String) async throws -> [Note] {
        print("🔍 searchFullText: '\(query)'")
        
        guard !query.isEmpty else {
            return try await getAll()
        }
        
        return try await db.read { db in
            let searchQuery = query
                .lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .split(whereSeparator: { !$0.isLetter && !$0.isNumber })
                .map { "\($0)*" }
                .joined(separator: " AND ")
            
            let sql = """
               SELECT notes.*
               FROM notes_fts
               JOIN notes ON notes.id = notes_fts.rowid
               WHERE notes_fts MATCH ?
               ORDER BY bm25(notes_fts)
           """
            
            return try Note.fetchAll(db, sql: sql, arguments: [searchQuery])
        }
    }
    
    
    func getSearchSuggestions(_ prefix: String) async throws -> [String] {
        try await db.read { db in
            let sql = """
                SELECT DISTINCT title FROM notes_fts
                WHERE title LIKE ?
                LIMIT 10
            """
            return try String.fetchAll(db, sql: sql, arguments: ["\(prefix)%"])
        }
    }
    
    func syncToCloud() async throws {
        // TODO: Implement cloud sync
        print("Cloud sync not implemented yet")
    }
}
