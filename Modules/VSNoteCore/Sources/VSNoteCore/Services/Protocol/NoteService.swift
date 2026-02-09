//
//  NoteService.swift
//  VSNoteCore
//
//  Created by ECO0611-VUVD on 9/2/26.
//


public protocol NoteService {
    func getAll() async throws -> [Note]
    func search(keyword: String) async throws  -> [Note]
    func save(_ note: Note) async throws
    func delete(_ noteId: Int64) async throws
    func upddate(_ note: Note) async throws
    func syncToCloud() async throws
}
