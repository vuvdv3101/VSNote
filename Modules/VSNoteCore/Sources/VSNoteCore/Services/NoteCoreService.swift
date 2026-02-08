//
//  NoteCoreService.swift
//  VSNoteCore
//
//  Created by Admin on 6/2/26.
//

import Combine

public protocol NoteService {
    func getAll() async throws -> [Note]
    func search(keyword: String) async throws  -> [Note]
    func save(_ note: Note) async throws
    func delete(_ noteId: Int64) async throws
    func upddate(_ note: Note) async throws
    func syncToCloud() async throws
}


public class NoteCoreService: NoteService {
    
    private let repository: NoteRepository
    
    public init() {
        let db = try! SQLService()
        self.repository = SQLRepository(db: db.pool)
    }
    
    public func getAll() async throws -> [Note] {
        try await repository.getAll()
    }
    
    public func search(keyword: String) async throws -> [Note] {
        if keyword.isEmpty {
            let allNotes = try await getAll()
            return allNotes
        }
        
        return try await repository.searchFullText(keyword)
        
    }
    
    public func save(_ note: Note) async throws {
        try await repository.save(note)
    }
    
    public func delete(_ noteId: Int64) async throws {
        try await repository.delete(noteId)

    }
    
    public func upddate(_ note: Note) async throws {
        try await repository.update(note)

    }
    
    public func syncToCloud() async throws {
        
    }    
}
