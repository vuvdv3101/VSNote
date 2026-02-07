//
//  SearchTextField.swift
//  VSNotes
//
//  Created by ECO0611-VUVD on 7/2/26.
//

import SwiftUI

struct SearchTextField: View {
    // MARK: - Properties
    @Binding var text: String
    @Binding var focusing: Bool
    
    @FocusState private var textFieldFocus: Bool
    
    var body: some View {
        HStack {
            
            TextField("", text: $text, prompt: placeholder)
                .fontDesign(.monospaced)
                .focused($textFieldFocus)
            
            if !text.isEmpty {
                Image(systemName: "xmark.circle.fill")
                    .onTapGesture {
                        onClear()
                    }
            }
           
        }
        .padding()
        .frame(maxHeight: 40)
        .background(Color.gray.opacity(0.2))
        .roundedCorner(20)
        .onChange(of: focusing, initial: false, {
            textFieldFocus = focusing
        })
        .onChange(of: textFieldFocus, initial: false, {
            focusing = textFieldFocus
        })
    }
    
    // MARK: - Views
    @ViewBuilder
    private var placeholder: Text {
        Text("Find your note")
            .foregroundColor(.gray)
            .fontDesign(.monospaced)
    }
    
    // MARK: - Methods
    private func onClear() {
        text = ""
    }
}

#Preview {
    SearchTextField(text: .constant("Hello"), focusing: .constant(true))
}
