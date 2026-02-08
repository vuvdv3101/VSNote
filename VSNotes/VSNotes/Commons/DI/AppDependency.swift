//
//  AppDependency.swift
//  VSNotes
//
//  Created by Admin on 9/2/26.
//

import FactoryKit
import VSNoteCore

extension Container {
    var noteService: Factory<NoteService> {
        Factory(self) {
            return NoteCoreService()
        }
    }
}
