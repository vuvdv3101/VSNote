//
//  NoteEditorScreen.swift
//  VSNotes
//
//  Created by ECO0611-VUVD on 7/2/26.
//

import SwiftUI

struct NoteEditorScreen: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 25))
                    .onTapGesture {
                        router.pop()
                    }
            }
            Spacer()
        }
        .padding()
        .background(Color.gray)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NoteEditorScreen()
}
