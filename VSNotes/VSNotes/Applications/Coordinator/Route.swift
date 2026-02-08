//
//  Route.swift
//  VSNotes
//
//  Created by ECO0611-VUVD on 7/2/26.
//
import SwiftUI

protocol Route: Hashable {
    associatedtype Child: View
    func view() -> Child
}

protocol Router {
    var path: NavigationPath { get set }
    func push(_ route: any Route)
    func pop()
    func popToRoot()
}

enum AppRoute: Route {
    case editor
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .editor:
            NoteEditorScreen()
        }
    }
}

@Observable
final class NavigationRouter: Router {
    var path = NavigationPath()
    
    func push(_ route: any Route) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
