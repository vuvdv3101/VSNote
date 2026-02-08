//
//  ContentView.swift
//  VSNotes
//
//  Created by Admin on 6/2/26.
//

import SwiftUI

struct ContentView: View {
    @State private var navigation: NavigationRouter = NavigationRouter()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            NoteListScreen()
                .navigationDestination(for: AppRoute.self, destination: { route in
                    route.view()
                })
        }
        .environment(navigation)
    }
}

#Preview {
    ContentView()
}
