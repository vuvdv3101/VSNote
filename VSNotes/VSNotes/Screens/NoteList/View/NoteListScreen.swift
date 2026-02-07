//
//  NoteListScreen.swift
//  VSNotes
//
//  Created by Admin on 7/2/26.
//

import SwiftUI

struct NoteListScreen: View {
    @Environment(Router.self) private var router
    @State private var viewModel: NoteListScreenViewModel = .init()
    @State private var isTextFieldFocusing: Bool = false
    @State private var navigationHeight: CGFloat = 50
    
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
            .contentMargins(.top, 8)
            .listStyle(.plain)
        }
        .simultaneousGesture(TapGesture().onEnded({ _ in
            dismissSearch()
        }))
        .overlay(alignment: .bottomTrailing) {
            FloatButtonView {
                router.push(AppRoute.editor)
            }
        }
    }
    
    @ViewBuilder
    private var navigationBar: some View {
        ZStack {
            HStack {
                SearchTextField(
                    text: $viewModel.searchValue,
                    focusing: $isTextFieldFocusing
                )
                .opacity(isTextFieldFocusing ? 1 : 0)
                .offset(y: isTextFieldFocusing ? 0 : 6)
            }

            HStack {
                Image(systemName: "signature")
                    .resizable()
                    .frame(width: 24, height: 24)

                Text("VSNotes")
                    .fontDesign(.monospaced)
                    .font(.title3)
                    .fontWeight(.medium)

                Spacer()

                Image("search")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            navigationHeight = 70
                            isTextFieldFocusing = true
                        }
                    }
            }
            .opacity(isTextFieldFocusing ? 0 : 1)
            .offset(y: isTextFieldFocusing ? -6 : 0)
        }
        .frame(minHeight: navigationHeight)
        .animation(.easeIn(duration: 0.2), value: navigationHeight)
    }
}

extension NoteListScreen {
    
    func dismissSearch() {
        withAnimation(.easeInOut(duration: 0.2)) {
            navigationHeight = 50
            isTextFieldFocusing = false
            viewModel.searchValue = ""
        }
    }
}

#Preview {
    NoteListScreen()
}


