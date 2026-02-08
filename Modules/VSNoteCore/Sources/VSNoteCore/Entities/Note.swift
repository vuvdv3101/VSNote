//
//  Note.swift
//  VSNoteCore
//
//  Created by Admin on 6/2/26.
//

import Foundation
import GRDB

public protocol NoteEntity: Equatable, Sendable {
    var id: Int64? { get }
    var title: String { get }
    var content: String { get }
    var createdAt: Double { get }
    var updatedAt: Double { get }
}

public struct Note: NoteEntity {
    public var id: Int64?
    public var title: String
    public var content: String
    public var createdAt: Double
    public var updatedAt: Double
    
    public init(id: Int64? = nil, title: String, content: String, createdAt: Double, updatedAt: Double) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Note: Codable, FetchableRecord, MutablePersistableRecord {
    public static let databaseTableName: String = "notes"
    enum Columns {
        static let title = Column(CodingKeys.title)
        static let content = Column(CodingKeys.content)
        static let createdAt = Column(CodingKeys.createdAt)
        static let updatedAt = Column(CodingKeys.updatedAt)
    }
    
    mutating public func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}

