//
//  Mock.swift
//  VSNotes
//
//  Created by Admin on 12/2/26.
//
import Foundation
import VSNoteCore

struct Mock {
    static var mockService: NoteService {
        do {
            let fileManager = FileManager.default
            let tempURL = fileManager.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathComponent("VSNote")
            
            try fileManager.createDirectory(at: tempURL, withIntermediateDirectories: true)
            let databaseURL = tempURL.appendingPathComponent("test_notes.sqlite")

            let dbProvider = try GRDBDatabaseProvider(url: databaseURL)

            let repository = SQLRepository(provider: dbProvider)
            return NoteCoreService(repository: repository)
        } catch {
            fatalError("[DI] error when inject dependencies: \(error)")
        }
    }
}
