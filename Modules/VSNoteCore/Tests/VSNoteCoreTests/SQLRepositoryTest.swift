//
//  Test.swift
//  VSNoteCore
//
//  Created by Admin on 9/2/26.
//

import Testing
import GRDB
import VSNoteCore
import Foundation

struct SQLRepositoryTest {

    @Test func test_save_to_db() async throws {
        let dbName = "test_\(UUID().uuidString).sqlite"
        let dbURL = try SQLiteURLBuilder(folderURL: FileManager.default.temporaryDirectory).getDbURL(name: dbName)
        let dbProvider = try GRDBDatabaseProvider(url: dbURL)
        let repository = SQLRepository(provider: dbProvider)
        
        let createdAt = Date().timeIntervalSince1970
        let note: Note = .init(title: "Test save new note", content: "This is test save new note content", createdAt: createdAt, updatedAt: createdAt)
        
        try await repository.save(note)
        let data = try await repository.getAll()
        #expect(data.count == 1)
        #expect(data[0].title == note.title)
        #expect(data[0].content == note.content)
        #expect(data[0].createdAt == note.createdAt)
        
        try? FileManager.default.removeItem(at: dbURL)

    }
    
    @Test func test_update_to_db() async throws {
        let dbName = "test_\(UUID().uuidString).sqlite"
        let dbURL = try SQLiteURLBuilder(folderURL: FileManager.default.temporaryDirectory).getDbURL(name: dbName)
        let dbProvider = try GRDBDatabaseProvider(url: dbURL)
        let repository = SQLRepository(provider: dbProvider)
        
        let createdAt = Date().timeIntervalSince1970
        let note: Note = .init(title: "Test update new note", content: "This is test save new note content", createdAt: createdAt, updatedAt: createdAt)
        let expectedString = "This is new content when user updated existing note"

        try await repository.save(note)
        let data = try await repository.getAll()
        
        var updatedNote = data[0]
        updatedNote.content = expectedString
        #expect(updatedNote.content == expectedString)
        
        try await repository.update(updatedNote)
        let newData = try await repository.getAll()
        
        #expect(data.count == 1)
        #expect(newData[0].title == updatedNote.title)
        #expect(newData[0].content == updatedNote.content)
        #expect(newData[0].createdAt == updatedNote.createdAt)
        
        try? FileManager.default.removeItem(at: dbURL)

    }
    
    @Test func test_delete_note() async throws {
        let dbName = "test_\(UUID().uuidString).sqlite"
        let dbURL = try SQLiteURLBuilder(folderURL: FileManager.default.temporaryDirectory).getDbURL(name: dbName)
        let dbProvider = try GRDBDatabaseProvider(url: dbURL)
        let repository = SQLRepository(provider: dbProvider)
        
        let createdAt = Date().timeIntervalSince1970
        let note: Note = .init(title: "Test add new note", content: "This is test save new note content", createdAt: createdAt, updatedAt: createdAt)
        
        try await repository.save(note)
        let data = try await repository.getAll()
        let  deletedNote = data[0]
        try await repository.delete(deletedNote.id ?? 0)
        let newData = try await repository.getAll()
        #expect(newData.count == 0)
        
        try? FileManager.default.removeItem(at: dbURL)

    }
    
    @Test func test_search_full_text() async throws {
        let dbName = "test_\(UUID().uuidString).sqlite"
        let dbURL = try SQLiteURLBuilder(folderURL: FileManager.default.temporaryDirectory).getDbURL(name: dbName)
        let dbProvider = try GRDBDatabaseProvider(url: dbURL)
        let repository = SQLRepository(provider: dbProvider)
        
        let createdAt = Date().timeIntervalSince1970
        let content = "“Shipmates, this book, containing only four chapters—four yarns—is one of the smallest strands in the mighty cable of the Scriptures. Yet what depths of the soul does Jonah’s deep sealine sound! what a pregnant lesson to us is this prophet! What a noble thing is that canticle in the fish’s belly! How billow-like and boisterously grand! We feel the floods surging over us; we sound with him to the kelpy bottom of the waters; sea-weed and all the slime of the sea is about us! But what is this lesson that the book of Jonah teaches? Shipmates, it is a two-stranded lesson; a lesson to us all as sinful men, and a lesson to me as a pilot of the living God. As sinful men, it is a lesson to us all, because it is a story of the sin, hard-heartedness, suddenly awakened fears, the swift punishment, repentance, prayers, and finally the deliverance and joy of Jonah. As with all sinners among men, the sin of this son of Amittai was in his wilful disobedience of the command of God—never mind now what that command was, or how conveyed—which he found a hard command. But all the things that God would have us do are hard for us to do—remember that—and hence, he oftener commands us than endeavors to persuade. And if we obey God, we must disobey ourselves; and it is in this disobeying ourselves, wherein the hardness of obeying God consists."
        let note: Note = .init(title: "Test save new note", content: content, createdAt: createdAt, updatedAt: createdAt)
        
        try await repository.save(note)
        let data = try await repository.searchFullText("conveyed—which")
        
        #expect(data.count == 1)
        #expect(data[0].title == note.title)
        #expect(data[0].content == note.content)
        #expect(data[0].createdAt == note.createdAt)
        
        try? FileManager.default.removeItem(at: dbURL)

    }
}
