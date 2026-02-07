//
//  NoteCellView.swift
//  VSNotes
//
//  Created by Admin on 7/2/26.
//

import SwiftUI

struct NoteCellView: View {
    let data: NoteCellDisplayModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(data.title)
                .fontDesign(.monospaced)
                .font(.callout)
                .fontWeight(.medium)
            
            Text(data.content)
                .fontDesign(.monospaced)
                .font(.caption)
                .fontWeight(.thin)
            
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
        .padding()
        .background(Color("bg-1"))
        .listRowSeparator(.hidden)
        .roundedCorner(8)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))

    }
}
