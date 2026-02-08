//
//  NoteListScreen.swift
//  VSNotes
//
//  Created by Admin on 7/2/26.
//

import SwiftUI

struct NoteListScreen: View {
    @Environment(NavigationRouter.self) private var router
    @State private var viewModel: NoteListScreenViewModel = .init()
    @State private var isFocused: Bool = false
    @State private var navigationHeight: CGFloat = 50
    
    var body: some View {
        VStack(alignment: .leading ,spacing: 0) {
            navigationBar
                .padding(.horizontal, 16)
            
            Text("List notes (\(viewModel.notes.count))")
                .fontDesign(.monospaced)
                .font(.callout)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            List(viewModel.notes, id: \.id) { note in
                NoteCellView(data: note, ontap: {
                    onSelectedNote(note)
                }, onDelete: {
                    onDeleteNote(note)
                })
            }
            .contentMargins(.top, 0)
            .listStyle(.plain)
        }
        .simultaneousGesture(TapGesture().onEnded({ _ in
            dismissSearch()
        }))
        .overlay(alignment: .bottomTrailing) {
            FloatButtonView {
                router.push(AppRoute.editor())
            }
        }
        .task {
            viewModel.fetchAllNote()
        }
    }
    
    @ViewBuilder
    private var navigationBar: some View {
        ZStack {
            HStack {
                SearchTextField(
                    text: $viewModel.searchValue,
                    focusing: $isFocused
                )
                .opacity(isFocused ? 1 : 0)
                .offset(y: isFocused ? 0 : 6)
            }

            HStack {
                AppIcons.appLogo
                    .resizable()
                    .frame(width: 24, height: 24)

                Text("VSNotes")
                    .fontDesign(.monospaced)
                    .font(.title3)
                    .fontWeight(.medium)

                Spacer()

                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            navigationHeight = 70
                            isFocused = true
                        }
                    }
            }
            .opacity(isFocused ? 0 : 1)
            .offset(y: isFocused ? -6 : 0)
        }
        .frame(minHeight: navigationHeight)
        .animation(.easeIn(duration: 0.2), value: navigationHeight)
    }
}

extension NoteListScreen {
    
    private func dismissSearch() {
        withAnimation(.easeInOut(duration: 0.2)) {
            navigationHeight = 50
            isFocused = false
            viewModel.searchValue = ""
        }
    }
    
    private func onSelectedNote(_ note: NoteCellDisplayModel) {
        router.push(AppRoute.editor(note: note))
    }
    
    private func onDeleteNote(_ note: NoteCellDisplayModel) {
        viewModel.delete(note: note)
    }
}

#Preview {
    NoteListScreen()
        .environment(NavigationRouter())
}


