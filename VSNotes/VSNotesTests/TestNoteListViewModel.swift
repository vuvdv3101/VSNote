//
//  TestNoteListViewModel.swift
//  VSNotesTests
//
//  Created by Admin on 12/2/26.
//

import Testing
@testable import VSNotes
import FactoryTesting
import FactoryKit
import VSNoteCore
import Foundation
import GRDB

struct TestNoteListViewModel {

    @Test(.container) func testNoteListViewModel() async throws {
        let injector = TestServiceInjector()
        injector.injectedNoteService()
        
        // Create test data
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
            createdAt: Date().timeIntervalSince1970 - 1000,
            updatedAt: Date().timeIntervalSince1970 - 1000
        )
        
        // Save test notes
        try await service.save(testNote1)
        try await Task.sleep(nanoseconds: 500_000_000) // 0.2 seconds
        try await service.save(testNote2)
        
        // Create viewModel and test
        let viewModel = NoteListScreenViewModel()
        
        // Test initial fetch
        viewModel.fetchAllNote()
        
        // Wait for async operation
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        #expect(viewModel.notes.count == 2)
        
        try? FileManager.default.removeItem(at: injector.dbURL!)
    }
    
    @Test(.container) func testNoteListViewModel_deleteNote() async throws {
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
        
        _ = try await service.save(testNote1)

        let viewModel = NoteListScreenViewModel()
        
        viewModel.fetchAllNote()
        try await Task.sleep(nanoseconds: 200_000_000)

        #expect(viewModel.notes.count == 1)
        
        viewModel.delete(note: viewModel.notes[0])
        
        viewModel.fetchAllNote()
        try await Task.sleep(nanoseconds: 200_000_000)
        #expect(viewModel.notes.count == 0)

    }
}

class TestServiceInjector {
    var dbURL: URL?
    
    func createDB() -> URL {
        do {
            // Setup test database
            let fileManager = FileManager.default
            let tempURL = fileManager.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathComponent("VSNote")
            
            try fileManager.createDirectory(at: tempURL, withIntermediateDirectories: true)
            let databaseURL = tempURL.appendingPathComponent("test_notes.sqlite")
            return databaseURL
        } catch let error {
            fatalError("[DI] error when create test database: \(error)")
        }
    }
    
    func injectedNoteService() {
        // Register test-specific dependency
        dbURL = createDB()
        guard let databaseURL = dbURL else {
            fatalError("[DI] databaseURL is nil")
        }
        Container.shared.noteService.register {
            do {
                let dbProvider = try GRDBDatabaseProvider(url: databaseURL)
                let repository = SQLRepository(provider: dbProvider)
                return NoteCoreService(repository: repository)
            } catch {
                fatalError("[DI] error when inject dependencies: \(error)")
            }
        }
    }
}
