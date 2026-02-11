//
//  TestNoteEditorViewModel.swift
//  VSNotesTests
//
//  Created by Admin on 10/2/26.
//

import Testing
@testable import VSNotes
import FactoryTesting
import FactoryKit
import VSNoteCore
import Foundation
import GRDB

struct TestNoteEditorViewModel {
    @Test(.container) func testNoteEditorViewModel() async throws {
        let injector = TestServiceInjector()
        injector.injectedNoteService()
        
        let viewModel = NoteEditorViewModel(note: nil, noteService: Container.shared.noteService.resolve())
        viewModel.note.title = "Test Save Note Title"
        viewModel.note.content = "Test Save Note Content"
        
        let task = viewModel.save()
        await task.value

        let service = Container.shared.noteService.resolve()
        let data = try await service.getAll()
        
        #expect(data.count == 1)
        #expect(data[0].title == "Test Save Note Title")
        #expect(data[0].content == "Test Save Note Content")
        
        try? FileManager.default.removeItem(at: injector.dbURL!)

    }
    
    @Test(.container) func testNoteListViewModel_updateNote() async throws {
        let injector = TestServiceInjector()
        injector.injectedNoteService()
        
        let service = Container.shared.noteService.resolve()
        let testNote1 = Note(
            id: nil,
            title: "Test Note 1",
            content: "Content for test note 1",
            createdAt: Date().timeIntervalSince1970,
            updatedAt: Date().timeIntervalSince1970
        )
        
        let testNote2 = Note(
            id: nil,
            title: "Test Note 2",
            content: "Content for test note 2",
            createdAt: Date().timeIntervalSince1970 + 1000,
            updatedAt: Date().timeIntervalSince1970 + 1000
        )
        
        _ = try await service.save(testNote1)
        _ = try await service.save(testNote2)

        let viewModel = NoteListScreenViewModel()
        
        viewModel.fetchAllNote()
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(viewModel.notes.count == 2)
        
        
        let updatedNote1 = viewModel.notes[1]
        #expect(updatedNote1.title == "Test Note 1")
        #expect(updatedNote1.id == 1)

        let updateViewModel = NoteEditorViewModel(note: updatedNote1, noteService: service)
        updateViewModel.note.content = "New content for test note 1"
        
        #expect(updateViewModel.note.content == "New content for test note 1")

        updateViewModel.save()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        viewModel.fetchAllNote()
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(viewModel.notes.count == 2)
        try? FileManager.default.removeItem(at: injector.dbURL!)
    }
}

