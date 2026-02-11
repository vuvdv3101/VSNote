# VSNote

A lightweight iOS note-taking application built with SwiftUI and modern Swift architecture patterns.

## Overview

VSNote is a simple yet powerful note-taking app designed for iOS 17+

## Features

- **Create and Edit Notes**: Simple interface for writing and editing notes
- **Full-Text Search**: Search through all your notes instantly
- **Modern iOS Design**: Built with SwiftUI for a native iOS experience
- **Local Storage**: Reliable SQLite database for data persistence
- **Well Tested**: Comprehensive unit and integration tests
- **Modular Architecture**: Clean separation of concerns with VSNoteCore module

## Architecture

VSNote follows the MVVM (Model-View-ViewModel) pattern with a modular architecture:

```
VSNote (Main App)
├── VSNoteCore (Module)
│   ├── Entities (Note data models)
│   ├── Persistence (Repository pattern)
│   └── Services (Business logic)
├── Screens (SwiftUI Views & ViewModels)
└── Commons (Shared utilities)
```

### Technology Stack

- **Language**: Swift 6.1
- **UI Framework**: SwiftUI
- **Database**: SQLite with GRDB.swift
- **Architecture**: MVVM + Repository Pattern
- **Testing**: Swift Testing framework
- **Minimum iOS**: 17.0

## Project Structure

```
VSNote/
├── VSNotes/                    # Main iOS application
│   ├── VSNotes/
│   │   ├── Applications/       # App entry point and assets
│   │   ├── Commons/           # Shared utilities and extensions
│   │   ├── Screens/           # SwiftUI screens and ViewModels
│   │   └── Applications/      # App configuration and routing
│   ├── VSNotesTests/          # Unit tests for ViewModels
│   └── VSNotesUITests/        # UI automation tests
├── Modules/
│   └── VSNoteCore/            # Core business logic module
│       ├── Sources/
│       │   └── VSNoteCore/
│       │       ├── Entities/  # Data models (Note entity)
│       │       ├── Persistence/ # Repository implementations
│       │       └── Services/  # Business logic services
│       └── Tests/             # Core module tests
└── README.md
```

## Core Components

### Note Entity
The fundamental data model representing a note with title, content, and timestamps.

### Repository Pattern
- `NoteRepository` protocol defines data access interface
- `SQLRepository` implements SQLite persistence using GRDB
- `GRDBDatabaseProvider` handles database connections

### Service Layer
- `NoteCoreService` provides business logic for note operations
- Supports CRUD operations and full-text search
- Designed for future cloud sync capabilities

### SwiftUI Views
- `NoteListScreen`: Displays all notes with search functionality
- `NoteEditorScreen`: Create and edit individual notes
- `NoteCellView`: Reusable note list item component

## Installation & Setup

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- Swift 6.1

### Building the Project
1. Clone the repository
2. Open `VSNotes/VSNotes.xcodeproj` in Xcode
3. Xcode will automatically resolve Swift Package dependencies (GRDB)
4. Build and run on iOS Simulator or device

### Running Tests
- **Unit Tests**: `⌘+U` to run all tests
- **Core Module Tests**: Run tests in `VSNoteCore` scheme
- **UI Tests**: Run tests in `VSNotesUITests` scheme

## Test Scenarios

### Core Module Tests (VSNoteCore)

#### CRUD Operations
- **Create**: Save new notes to database
- **Read**: Retrieve all notes and individual notes
- **Update**: Modify existing note content and title
- **Delete**: Remove notes from database

#### Search Functionality
- **Full-Text Search**: Search within note content and titles
- **Empty Search**: Return all notes when search is empty
- **Partial Matches**: Find notes with partial keyword matches

#### Database Operations
- **Database Creation**: Automatic database setup
- **Migration Handling**: Schema version management
- **Connection Management**: Proper database connection lifecycle

### App Integration Tests (VSNotes)

#### ViewModel Tests
- **Note Creation**: Test creating notes through ViewModel
- **Note Editing**: Test updating existing notes
- **Note Listing**: Test displaying notes in list view
- **Search Integration**: Test search functionality through ViewModel

#### Data Flow Tests
- **Persistence**: Ensure notes persist between app launches
- **State Management**: Test ViewModel state updates
- **Error Handling**: Test error scenarios and recovery
