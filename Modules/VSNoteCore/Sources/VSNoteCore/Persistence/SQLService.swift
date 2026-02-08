//
//  SQLService.swift
//  VSNoteCore
//
//  Created by Admin on 6/2/26.
//

import GRDB
import Foundation

public final class SQLService {
    public let pool: DatabasePool
    
    public init() throws {
        debugPrint("[SQL CORE] setup db service....")
        let fileManager = FileManager.default
        let folderURL = try fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("VSNote", isDirectory: true)
        
        try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        
        let databaseURL = folderURL.appendingPathComponent("notes.sqlite")
        debugPrint("[SQL CORE] created url: \(databaseURL)")
        self.pool = try DatabasePool(path: databaseURL.path)
        
        try setupDatabase()
        debugPrint("[SQL CORE] setup database service DONE....")
    }
    
    private func setupDatabase() throws {
        debugPrint("[SQL CORE] setup database table....")
        try pool.write { db in
            // Main notes table
            try db.create(table: "notes", ifNotExists: true) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
                t.column("content", .text).notNull()
                t.column("createdAt", .double).notNull()
                t.column("updatedAt", .double).notNull()
            }
            
            try db.create(virtualTable: "notes_fts", using: FTS5()) { t in
                t.content = "notes"
                t.tokenizer = .unicode61(diacritics: .removeLegacy)
                t.column("content")
                t.column("title")
            }
            
            
            try db.execute(sql: """
                CREATE TRIGGER IF NOT EXISTS notes_fts_update AFTER UPDATE ON notes BEGIN
                    UPDATE notes_fts SET title = new.title, content = new.content WHERE rowid = new.id;
                END
            """)

            try db.execute(sql: """
                CREATE TRIGGER IF NOT EXISTS notes_fts_delete AFTER DELETE ON notes BEGIN
                    DELETE FROM notes_fts WHERE rowid = old.id;
                END
            """)
            
            // Performance indexes
            try db.execute(sql: "CREATE INDEX IF NOT EXISTS idx_note_createdAt ON notes(createdAt DESC)")
            try db.execute(sql: "CREATE INDEX IF NOT EXISTS idx_note_updatedAt ON notes(updatedAt DESC)")
        }
        debugPrint("[SQL CORE] setup database successfully....")
    }
}
