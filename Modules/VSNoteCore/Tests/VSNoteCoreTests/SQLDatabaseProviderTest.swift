//
//  Test.swift
//  VSNoteCore
//
//  Created by ECO0611-VUVD on 9/2/26.
//

import Testing
import GRDB
import VSNoteCore
import Foundation

struct SQLDatabaseProviderTest {
    
    // Test db init with notes and FTS table
    @Test func test_database_initialization() async throws {
        
        let dbPool = try createPool()
        let db = try GRDBDatabaseProvider(pool: dbPool.pool)

        try await db.pool.read { db in
            let isNoteTableExist = try db.tableExists("notes")
            let isNoteFTSTableExist = try db.tableExists("notes_fts")
            try? FileManager.default.removeItem(at: dbPool.url)
            #expect(isNoteTableExist)
            #expect(isNoteFTSTableExist)
            
        }
    }
    
    // Test main table "note" schema is correct
    @Test func test_notes_table_schema() async throws {
        let dbPool = try createPool()
        let provider = try GRDBDatabaseProvider(pool: dbPool.pool)
        
        try await provider.pool.read { db in
            let columns = try db.columns(in: "notes")
            
            let columnNames = columns.map { $0.name }
            #expect(columnNames.contains("id"))
            #expect(columnNames.contains("title"))
            #expect(columnNames.contains("content"))
            #expect(columnNames.contains("createdAt"))
            #expect(columnNames.contains("updatedAt"))
            
            // verify column value type
            let idColumn = columns.first { $0.name == "id" }
            #expect(idColumn?.type == "INTEGER")
            
            let titleColumn = columns.first { $0.name == "title" }
            #expect(titleColumn?.type == "TEXT")
            
            let contentColumn = columns.first { $0.name == "content" }
            #expect(contentColumn?.type == "TEXT")
            
            let createAtColumn = columns.first { $0.name == "createdAt" }
            #expect(createAtColumn?.type == "DOUBLE")
            
            let updateAtColumn = columns.first { $0.name == "updatedAt" }
            #expect(updateAtColumn?.type == "DOUBLE")
            
            // note_fts
            
            let columns_fts = try db.columns(in: "notes_fts")
            
            let columnFTSNames = columns_fts.map { $0.name }
            #expect(columnFTSNames.contains("title"))
            #expect(columnFTSNames.contains("content"))
        }
    }
    
    @Test func test_notes_fts_table_schema() async throws {
        let dbPool = try createPool()
        let provider = try GRDBDatabaseProvider(pool: dbPool.pool)
        
        try await provider.pool.read { db in
            let columns = try db.columns(in: "notes_fts")
            
            let columnNames = columns.map { $0.name }
            #expect(columnNames.contains("title"))
            #expect(columnNames.contains("content"))
        }
    }
}

// MARK: - Support function
extension SQLDatabaseProviderTest {
    private func createDatabaseURL() -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let dbURL = tempDir.appendingPathComponent("test_\(UUID().uuidString).sqlite")
        return dbURL
    }
    
    private func createPool() throws -> (pool: DatabasePool,url: URL) {
        let dbURL = createDatabaseURL()
        let config = Configuration()
        return try (DatabasePool(path: dbURL.path(), configuration: config), dbURL)
    }
}
