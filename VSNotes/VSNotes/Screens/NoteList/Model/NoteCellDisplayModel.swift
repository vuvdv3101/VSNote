//
//  NoteCellDisplayModel.swift
//  VSNotes
//
//  Created by ECO0611-VUVD on 7/2/26.
//

import VSNoteCore
import Foundation
import VSNoteCore

struct NoteCellDisplayModel: Equatable, Hashable, Identifiable, NoteEntity {
   
    let id: Int64?
    var title: String
    var content: String
    var time: String
    var category: String
    var createdAt: Double?
    var updatedAt: Double?
    static let placeholder: NoteCellDisplayModel = .init(id: 1, title: "Way to success early", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", time: "20 Feb 2026", category: "Design | Wireframe")
    
    static let dateFormatter: DateFormatter = .init()
    
    static func fromNote(_ model: Note) -> NoteCellDisplayModel {
        let dateFormatter: DateFormatter = NoteCellDisplayModel.dateFormatter
        dateFormatter.dateFormat = "dd MMM yyyy"
        let updateTimeString = dateFormatter.string(from: Date(timeIntervalSince1970: model.updatedAt ?? Date().timeIntervalSince1970))
        return .init(id: model.id,title: model.title, content: model.content, time: updateTimeString, category: "Design|Wireframe", createdAt: model.createdAt, updatedAt: model.updatedAt)
    }
    
    func toNoteEntity() -> Note {
        let note: Note = Note.init(id: id, title: title, content: content, createdAt: createdAt, updatedAt: updatedAt)
        return note
    }
}

