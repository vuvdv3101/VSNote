//
//  NoteListScreenViewModel.swift
//  VSNotes
//
//  Created by ECO0611-VUVD on 7/2/26.
//
import SwiftUI
import VSNoteCore
import FactoryKit

@Observable
final class NoteListScreenViewModel {
    @Injected(\.noteService) private var noteService

    var searchValue: String = ""
    var notes: [NoteCellDisplayModel] = []

    func fetchAllNote() {
        Task {
            let data = try await noteService.getAll()
        }
    }
}
