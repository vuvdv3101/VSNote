//
//  AppDependency.swift
//  VSNotes
//
//  Created by Admin on 9/2/26.
//

import FactoryKit
import VSNoteCore
import Foundation

extension Container {
    var noteService: Factory<NoteService?> {
        Factory(self) {
            do {
                let dbURL = try SQLiteURLBuilder(folderURL: FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)).getDbURL(name: "notes.sqlite")
                let dbProvider = try GRDBDatabaseProvider(url: dbURL)
                let repository = SQLRepository(provider: dbProvider)
                return NoteCoreService(repository: repository)
            } catch let e {
                debugPrint("[DI] error when inject dependencies: \(e)")
                return nil
            }
            
        }
    }
}
