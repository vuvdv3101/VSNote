//
//  Test.swift
//  VSNoteCore
//
//  Created by ECO0611-VUVD on 9/2/26.
//

import Testing
import GRDB
import VSNoteCore

struct Test {

    @Test func test_create_db() async throws {
        let config = Configuration()
        let pool = try DatabasePool(path: ":memory:", configuration: config)

        let db = try GRDBDatabaseProvider(pool: pool)

        try await db.pool.read { db in
            #expect(try db.tableExists("notes"))
        }
    }

}
