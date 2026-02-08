//
//  NoteCellDisplayModel.swift
//  VSNotes
//
//  Created by ECO0611-VUVD on 7/2/26.
//

import VSNoteCore
import Foundation

struct NoteCellDisplayModel: Equatable, Hashable, Identifiable {
    let id: Int64?
    var title: String
    var content: String
    var time: String
    var category: String
    
    static let placeholder: NoteCellDisplayModel = .init(id: 1, title: "Way to success early", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", time: "20 Feb 2026", category: "Design | Wireframe")
    
    static let dateFormatter: DateFormatter = .init()
    
    static func fromNote(_ model: Note) -> NoteCellDisplayModel {
        let dateFormatter: DateFormatter = NoteCellDisplayModel.dateFormatter
        dateFormatter.dateFormat = "dd MMM yyyy"
        let updateTimeString = dateFormatter.string(from: Date(timeIntervalSince1970: model.updatedAt))
        return .init(id: model.id,title: model.title, content: model.content, time: updateTimeString, category: "Design|Wireframe")
    }
}

