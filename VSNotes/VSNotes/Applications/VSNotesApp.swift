//
//  VSNotesApp.swift
//  VSNotes
//
//  Created by Admin on 6/2/26.
//

import SwiftUI
import FactoryKit
import VSNoteCore

@main
struct VSNotesApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension Container {
    var noteService: Factory<NoteService> {
        Factory(self) {
            let sql = try! SQLService()
            let noteRepository: NoteRepository = SQLRepositoryImpl(db: sql.pool)
            return NoteCoreServiceImpl(repository: noteRepository)
        }
    }
}
