//
//  NoteListScreen.swift
//  VSNotes
//
//  Created by Admin on 7/2/26.
//

import SwiftUI

struct NoteCellDisplayModel: Identifiable {
    let id: Int64 = 1
    let title: String
    let content: String
    let time: String
    let category: String
    
    static let placeholder: NoteCellDisplayModel = .init(title: "Way to success early", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", time: "20 Feb 2026", category: "Design | Wireframe")
        
}

@Observable
final class NoteListScreenViewModel {
    
}
struct NoteListScreen: View {
    var body: some View {
        VStack(alignment: .leading ,spacing: 0) {
            navigationBar
                .padding(.horizontal, 16)

            List {
                NoteCellView(data: NoteCellDisplayModel.placeholder)
                NoteCellView(data: NoteCellDisplayModel.placeholder)

                NoteCellView(data: NoteCellDisplayModel.placeholder)

                NoteCellView(data: NoteCellDisplayModel.placeholder)

                NoteCellView(data: NoteCellDisplayModel.placeholder)

                NoteCellView(data: NoteCellDisplayModel.placeholder)

            }
            .refreshable {
                
            }
            .contentMargins(.top, 16)
            .listStyle(.plain)
        }
        .overlay(alignment: .bottomTrailing) {
            FloatButtonView()
        }
    }
    
    @ViewBuilder
    private var navigationBar: some View {
        HStack {
            Image("pinned-notes")
                .resizable()
                .frame(width: 24, height: 24)
            Text("V-Notes")
                .fontDesign(.monospaced)
                .font(.title3)
                .fontWeight(.medium)
            
            Spacer()
            Image("search")
                .resizable()
                .frame(width: 24, height: 24)
        }
        .frame(minHeight: 44)
    }
}

#Preview {
    NoteListScreen()
}


