//
//  Note.swift
//  VSNoteCore
//
//  Created by Admin on 6/2/26.
//

import Foundation
import GRDB

public protocol NoteEntity: Equatable, Sendable {
    var id: Int64 { get }
    var title: String { get }
    var content: String { get }
    var createdAt: TimeInterval { get }
    var updatedAt: TimeInterval { get }
}

public struct Note: NoteEntity {
    public var id: Int64
    public var title: String
    public var content: String
    public var createdAt: TimeInterval
    public var updatedAt: TimeInterval
}

extension Note: Codable, FetchableRecord, MutablePersistableRecord {
    enum Columns {
        static let tile = Column(CodingKeys.title)
        static let text = Column(CodingKeys.content)
        static let createdAt = Column(CodingKeys.createdAt)
        static let updateAt = Column(CodingKeys.updatedAt)
    }
    
    mutating public func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
