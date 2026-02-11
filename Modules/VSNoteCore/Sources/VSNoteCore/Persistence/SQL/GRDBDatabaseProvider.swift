//
//  SQLService.swift
//  VSNoteCore
//
//  Created by Admin on 6/2/26.
//

import GRDB
import Foundation

public protocol DatabaseProviding {
    var pool: DatabasePool { get }
}

public struct SQLiteURLBuilder {
    let folderURL: URL
    public init (folderURL: URL) {
        self.folderURL = folderURL
    }
    public func getDbURL(name: String) throws -> URL {
        let fileManager = FileManager.default
        let folderURL = folderURL
            .appendingPathComponent("VSNote", isDirectory: true)
        
        try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        
        let databaseURL = folderURL.appendingPathComponent(name)
        return databaseURL
    }
}

public final class GRDBDatabaseProvider: DatabaseProviding {
    public let pool: DatabasePool
    public init(url: URL) throws {
        debugPrint("[SQL CORE] setup db service....")
        debugPrint("[SQL CORE] created url: \(url)")
        self.pool = try DatabasePool(path: url.path)
        
        try setupTableAndMigrations()
        debugPrint("[SQL CORE] setup database service DONE....")
    }
    
    private func setupTableAndMigrations() throws {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("v1") { db in
            try db.create(table: "notes", ifNotExists: true) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
                t.column("content", .text).notNull()
                t.column("createdAt", .double).notNull()
                t.column("updatedAt", .double).notNull()
            }
            let ftsExists = try db.tableExists("notes_fts")
            
            if ftsExists {
                return
            }
            // FTS5 table
            try db.create(virtualTable: "notes_fts", using: FTS5()) { t in
                t.tokenizer = .unicode61(diacritics: .removeLegacy)
                t.column("title")
                t.column("content")
            }
            
            // Triggers
            try db.execute(sql: """
                CREATE TRIGGER IF NOT EXISTS notes_fts_insert AFTER INSERT ON notes BEGIN
                    INSERT INTO notes_fts(rowid, title, content) 
                    VALUES (NEW.id, NEW.title, NEW.content);
                END
            """)
            
            try db.execute(sql: """
                CREATE TRIGGER IF NOT EXISTS notes_fts_update AFTER UPDATE ON notes BEGIN
                    UPDATE notes_fts SET title = NEW.title, content = NEW.content 
                    WHERE rowid = NEW.id;
                END
            """)
            
            try db.execute(sql: """
                CREATE TRIGGER IF NOT EXISTS notes_fts_delete AFTER DELETE ON notes BEGIN
                    DELETE FROM notes_fts WHERE rowid = OLD.id;
                END
            """)
            
            // Indexes
            try db.execute(sql: "CREATE INDEX IF NOT EXISTS idx_note_createdAt ON notes(createdAt DESC)")
            try db.execute(sql: "CREATE INDEX IF NOT EXISTS idx_note_updatedAt ON notes(updatedAt DESC)")
        }
        
        //
//        migrator.registerMigration("v2") { db in
//            try db.alter(table: "notes") { t in
//                t.add(column: "tags", .text)
//            }
//        }

        
        // Run migrations
        try migrator.migrate(pool)
    }
}
