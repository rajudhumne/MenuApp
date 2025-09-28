# Architecture Overview

## Design Patterns

### MVVM (Model-View-ViewModel)
- **Models**: `MenuItem`, `MenuItemDetail` - Data structures
- **Views**: View Controllers and UI components
- **ViewModels**: `MenuViewModel` - Business logic and data binding

### Repository Pattern
- **MenuRepository**: Abstracts data access layer
- Provides clean interface between ViewModels and data sources
- Enables easy testing and data source switching

### Protocol-Oriented Programming
- All major components implement protocols
- Enables dependency injection and testability
- Examples: `NetworkManagerProtocol`, `MenuViewModelProtocol`

## Key Components

### Network Layer
- **NetworkManager**: Handles HTTP requests and response parsing
- **MenuRouter**: Defines API endpoints and request building
- **Error Handling**: Centralized error management

### Data Flow
1. View Controller triggers action
2. ViewModel processes business logic
3. Repository fetches data from network
4. ViewModel updates UI through delegate pattern

### Dependency Injection
- View Controllers accept dependencies in initializers
- Enables easy testing with mock objects
- Follows SOLID principles

## Testing Strategy

- **Unit Tests**: Test individual components in isolation
- **Protocol Mocks**: Mock dependencies for testing
- **Repository Tests**: Test data access logic
- **ViewModel Tests**: Test business logic without UI

## Error Handling

- Centralized error handling through `ErrorHandler`
- User-friendly error messages
- Graceful degradation for network issues

