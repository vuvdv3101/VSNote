//
//  NoteEditorScreen.swift
//  VSNotes
//
//  Created by ECO0611-VUVD on 7/2/26.
//

import SwiftUI
import FactoryKit
import VSNoteCore

struct NoteEditorScreen: View {
    @Environment(NavigationRouter.self) private var router
    @FocusState private var isFocused: Bool
    @State private var viewModel: NoteEditorViewModel
    init(_ viewModel: NoteEditorViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            navigationBar
            textEditorView
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    private var navigationBar: some View {
        HStack {
            AppIcons.backIcon
                .font(.system(size: 25))
                .onTapGesture {
                    router.pop()
                }
            Spacer()
            Text("Save")
                .fontDesign(.monospaced)
                .foregroundStyle(Color.blue)
                .onTapGesture {
                    Task {
                        await viewModel.save().value
                        router.pop()
                    }
                }
        }
        .frame(height: 50)
    }
    
    @ViewBuilder
    var textEditorView: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $viewModel.note.content)
                .fontDesign(.monospaced)
                .focused($isFocused)

            if viewModel.note.content.isEmpty {
                Text("Start typing…")
                    .fontDesign(.monospaced)
                    .foregroundStyle(.gray)
                    .padding(.top, 8)
                    .padding(.leading, 5)
                    .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    let _ = Container.shared.noteService.register {
        Mock.mockService
    }

    let viewModel = NoteEditorViewModel(note: nil, noteService: Container.shared.noteService.resolve())
    NoteEditorScreen(viewModel)
        .environment(NavigationRouter())
}

