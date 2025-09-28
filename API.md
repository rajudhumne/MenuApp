# API Documentation

## Core Classes

### AppConfig
Type-safe configuration management for environment variables.

```swift
// Get configuration value
let baseUrl: String = AppConfig.value(for: .baseApiUrl)
```

### NetworkManager
Handles HTTP requests and response parsing with error handling.

```swift
// Execute a request
let response: MenuResponse = try await networkManager.execute(request, responseType: MenuResponse.self)
```

### MenuViewModel
Business logic layer for menu operations.

```swift
// Load menu data
try await viewModel.loadMenu()

// Select menu item
try await viewModel.selectItem(at: itemId)
```

## Protocols

### NetworkManagerProtocol
```swift
protocol NetworkManagerProtocol {
    func execute<T: Decodable>(_ request: URLRequest, responseType: T.Type) async throws -> T
}
```

### MenuViewModelProtocol
```swift
protocol MenuViewModelProtocol {
    var delegate: MenuViewModelDelegateProtocol? { get set }
    func loadMenu() async throws
    func selectItem(at id: Int) async throws
}
```

## Error Types

### NetworkError
- `invalidResponse`: Non-HTTP response received
- `httpError(Int)`: HTTP status code error
- `decodingError(Error)`: JSON parsing failed

### AppConfig.Error
- `missingKey`: Configuration key not found
- `invalidValue`: Value cannot be converted to requested type

## Usage Examples

### Basic Network Request
```swift
let request = URLRequest(url: URL(string: "https://api.example.com/menu")!)
let menuItems: [MenuItem] = try await networkManager.execute(request, responseType: [MenuItem].self)
```

### Configuration Access
```swift
let apiUrl: String = AppConfig.value(for: .baseApiUrl)
let timeout: Int = AppConfig.value(for: .timeout)
```

