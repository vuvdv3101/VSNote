//
//  TestNoteEditorViewModel.swift
//  VSNotesTests
//
//  Created by Admin on 10/2/26.
//

import Testing
@testable import VSNotes
import FactoryKit
import VSNoteCore
import Foundation

struct TestNoteEditorViewModel {
    @Injected(\.noteService) var noteService
    
    @Test func testNoteEditorViewModel() async throws {
        Container.shared.noteService.register {
            do {
                let dbURL = try SQLiteURLBuilder(folderURL: FileManager.default.temporaryDirectory).getDbURL(name: "notes.sqlite")
                let dbProvider = try GRDBDatabaseProvider(url: dbURL)
                let repository = SQLRepository(provider: dbProvider)
                return NoteCoreService(repository: repository)
            } catch let e {
                debugPrint("[DI] error when inject dependencies: \(e)")
                return nil
            }
        }
        let viewModel = NoteEditorViewModel(note: nil)
        viewModel.note.title = "Test Save Note Title"
        viewModel.note.content = "Test Save Note Content"
        viewModel.save()
        
        let data = try await noteService?.getAll() ?? []
        #expect(data.count == 1)
        #expect(data[0].title == "Test Save Note Title")
        #expect(data[0].content == "Test Save Note Content")
    }

}

