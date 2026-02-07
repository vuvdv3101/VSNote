//
//  VSNotesApp.swift
//  VSNotes
//
//  Created by Admin on 6/2/26.
//

import SwiftUI

@main
struct VSNotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var navigation: NavigationRouter = NavigationRouter()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            NoteListScreen()
                .navigationDestination(for: AppRoute.self, destination: { target in
                    target
                        .view()
                })
        }
        .environment(navigation)
    }
}
