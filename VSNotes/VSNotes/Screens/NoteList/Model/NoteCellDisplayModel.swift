//
//  NoteCellDisplayModel.swift
//  VSNotes
//
//  Created by ECO0611-VUVD on 7/2/26.
//


struct NoteCellDisplayModel: Identifiable {
    let id: Int64 = 1
    let title: String
    let content: String
    let time: String
    let category: String
    
    static let placeholder: NoteCellDisplayModel = .init(title: "Way to success early", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", time: "20 Feb 2026", category: "Design | Wireframe")
        
}