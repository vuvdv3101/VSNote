//
//  AppDependency.swift
//  VSNotes
//
//  Created by Admin on 9/2/26.
//

import FactoryKit
import VSNoteCore

extension Container {
    var noteService: Factory<NoteService?> {
        Factory(self) {
            do {
                let db = try SQLService()
                let repository = SQLRepository(db: db.pool)
                return NoteCoreService(repository: repository)
            } catch let e {
                debugPrint("[DI] error when inject dependencies: \(e)")
                return nil
            }
            
        }
    }
}
