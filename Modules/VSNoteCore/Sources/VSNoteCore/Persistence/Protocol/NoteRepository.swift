//
//  NoteRepository.swift
//  VSNoteCore
//
//  Created by Admin on 6/2/26.
//

import Foundation
import GRDB

public protocol NoteRepository {
    func getAll() async throws -> [Note]
    func save(_ note: Note) async throws
    func delete(_ noteId: Int64) async throws
    func update(_ note: Note) async throws
    func search(keyword: String) async throws -> [Note]
    func searchFullText(_ query: String) async throws -> [Note]
    func getSearchSuggestions(_ prefix: String) async throws -> [String]
    func syncToCloud() async throws
}

