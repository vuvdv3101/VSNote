//
//  NoteEditorViewModel.swift
//  VSNotes
//
//  Created by ECO0611-VUVD on 7/2/26.
//

import SwiftUI
import FactoryKit
import VSNoteCore

@Observable
final class NoteEditorViewModel {
    var note: NoteCellDisplayModel
    let noteService: NoteService
    
    init(note: NoteCellDisplayModel?, noteService: NoteService) {
        self.noteService = noteService
        self.note = note ?? .init(id: nil, title: "", content: "", time: "", category: "")
    }
    
    @discardableResult
    func save() -> Task<Void, Never> {
        guard let noteid = note.id else {
            return createNote()
        }
        return updateNote(id: noteid)
    }
    
    private func createNote() -> Task<Void, Never> {
        return Task {
            let now = Date().timeIntervalSince1970
            let noteEntity = Note(
                id: nil,
                title: note.title.isEmpty ? "Untitled" : note.title,
                content: note.content,
                createdAt: now,
                updatedAt: now
            )
            do {
                try await noteService.save(noteEntity)
                debugPrint("Save success")
            } catch let e {
                debugPrint("Save error: \(e)")
            }
        }
    }
    
    private func updateNote(id: Int64) -> Task<Void, Never> {
        return Task {
            
            do {
                try await noteService.update(note.toNoteEntity())
                debugPrint("Update success")
            } catch let e {
                debugPrint("Save error: \(e)")
            }
        }
    }
}
