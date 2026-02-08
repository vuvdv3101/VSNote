//
//  NoteEditorScreen.swift
//  VSNotes
//
//  Created by ECO0611-VUVD on 7/2/26.
//

import SwiftUI

struct NoteEditorScreen: View {
    @Environment(NavigationRouter.self) private var router
    @FocusState private var isFocused: Bool
    @State private var viewModel: NoteEditorViewModel = .init()
    
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
                .foregroundStyle(Color.gray)
        }
        .frame(height: 50)
    }
    
    @ViewBuilder
    var textEditorView: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $viewModel.noteContent)
                .fontDesign(.monospaced)
                .focused($isFocused)

            if viewModel.noteContent.isEmpty && !isFocused {
                Text("Start typing…")
                    .fontDesign(.monospaced)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                    .padding(.leading, 5)
                    .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    NoteEditorScreen()
        .environment(NavigationRouter())
}
