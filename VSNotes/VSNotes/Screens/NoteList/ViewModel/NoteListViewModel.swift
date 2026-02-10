//
//  NoteListScreenViewModel.swift
//  VSNotes
//
//  Created by ECO0611-VUVD on 7/2/26.
//
import SwiftUI
import VSNoteCore
import FactoryKit
import Combine

@Observable
final class NoteListScreenViewModel {
    @ObservationIgnored @Injected(\.noteService) private var noteService

    var searchValue: String = "" {
        didSet {
            searchSubject.send(searchValue)
        }
    }
    var notes: [NoteCellDisplayModel] = []
   
    private let searchSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupObserver()
    }
    
    private func setupObserver() {
        searchSubject
            .debounce(for: 0.25, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self else { return }
                self.search(value)
            })
            .store(in: &cancellables)
    }
    
    func fetchAllNote() {
        search("")
    }
    
    func delete(note: NoteCellDisplayModel) {
        guard let noteId = note.id else { return }
        Task {
            try! await noteService?.delete(noteId)
            fetchAllNote()
        }
    }
    
    func search(_ keyword: String) {
        Task {
            do {
                let data = try await noteService?.search(keyword: keyword)
                notes = data?.map({ NoteCellDisplayModel.fromNote($0) }) ?? []
            } catch let e {
                debugPrint("Search error: \(e)")
            }
        }
    }
}
