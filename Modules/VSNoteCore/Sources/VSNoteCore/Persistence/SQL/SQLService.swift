//
//  SQLService.swift
//  VSNoteCore
//
//  Created by Admin on 6/2/26.
//

import GRDB
import Foundation

final class SQLService {
    let pool: DatabasePool
    
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
        
        try createDatabaseTable()
        debugPrint("[SQL CORE] setup database service DONE....")
    }
    
    private func createDatabaseTable() throws {
        debugPrint("[SQL CORE] setup database table....")
            try pool.write { db in
                try db.create(table: "notes", ifNotExists: true) { t in
                    t.autoIncrementedPrimaryKey("id")
                    t.column("title", .text).notNull()
                    t.column("content", .text).notNull()
                    t.column("createdAt", .double).notNull()
                    t.column("updatedAt", .double).notNull()
                }
                
                let ftsExists = try db.tableExists("notes_fts")
                guard !ftsExists else {
                    return
                }

                try db.create(virtualTable: "notes_fts", using: FTS5()) { t in
                    t.tokenizer = .unicode61(diacritics: .removeLegacy)
                    t.column("title")
                    t.column("content")
                }
                
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
                
                // Populate FTS với existing data
                try db.execute(sql: """
                    INSERT INTO notes_fts(rowid, title, content)
                    SELECT id, title, content FROM notes
                """)
                
                // Performance indexes
                try db.execute(sql: "CREATE INDEX IF NOT EXISTS idx_note_createdAt ON notes(createdAt DESC)")
                try db.execute(sql: "CREATE INDEX IF NOT EXISTS idx_note_updatedAt ON notes(updatedAt DESC)")
                
                debugPrint("[SQL CORE] FTS setup completed")
            }
    }
}
