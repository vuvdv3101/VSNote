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
    @ObservationIgnored @Injected(\.noteService) private var noteService
    var note: NoteCellDisplayModel
    
    init(note: NoteCellDisplayModel?) {
        self.note = note ?? .init(id: 0, title: "", content: "", time: "", category: "")
    }
    
    func save() {
        Task {
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
}
