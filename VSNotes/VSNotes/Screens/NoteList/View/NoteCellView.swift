//
//  NoteCellView.swift
//  VSNotes
//
//  Created by Admin on 7/2/26.
//

import SwiftUI

struct NoteCellView: View {
    let data: NoteCellDisplayModel
    var ontap: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
                Text(data.content)
                .fontDesign(.monospaced)
                .font(.caption)
                .fontWeight(.thin)
                .lineLimit(4)
            
            HStack {
                Text(data.category)
                    .fontDesign(.monospaced)
                    .font(.caption2)
                    .fontWeight(.thin)
                    .foregroundStyle(.secondary)
                Spacer(minLength: 30)
                Text(data.time)
                    .fontDesign(.monospaced)
                    .font(.caption2)
                    .fontWeight(.thin)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(getBackgroundColor())
        .listRowSeparator(.hidden)
        .roundedCorner(8)
        .onTapGesture {
            ontap()
        }
        .swipeActions(edge: .trailing) {
            deleteButton
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
    
    @ViewBuilder
    private var deleteButton: some View {
        Button(role: .destructive) {
            onDelete()
        } label: {
            Label("", systemImage: "trash")
                .fontDesign(.monospaced)
                .font(.caption2)
        }
    }
    
    private func getBackgroundColor() -> Color {
        let id = (data.id ?? 0) % 4
        return Color("bg-\(id)")
    }
}

#Preview {
    NoteCellView(data: .init(id: 0, title: "", content: "The note content displayed here", time: "12 Feb 2026", category: "Money|Travel"), ontap: {}, onDelete: {})
}
