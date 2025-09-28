# MenuApp

A simple iOS app that displays a restaurant menu with categories and item details.

## Features

- Browse menu items organized by categories
- View detailed information for each menu item
- Clean, modern UI with loading states
- Error handling and user feedback

## Architecture

- **MVVM Pattern**: ViewModels handle business logic
- **Repository Pattern**: Data access abstraction
- **Protocol-Oriented**: Dependency injection for testability
- **Async/Await**: Modern Swift concurrency

## Project Structure

```
MenuApp/
├── Controllers/          # View Controllers
├── ViewModels/          # Business Logic
├── Models/              # Data Models
├── Repositories/        # Data Access Layer
├── Managers/            # Utility Classes
├── Protocols/           # Protocol Definitions
├── DataSources/         # Table View Data Sources
├── Config/              # Configuration Files
└── Util/                # Extensions & Utilities
```

## Setup

1. Open `MenuApp.xcodeproj` in Xcode
2. Build and run on iOS Simulator or device
3. The app will load menu data from the configured API endpoint

## Configuration

The app uses xcconfig files for environment-specific configuration:

- **Staging.xcconfig**: Contains API endpoint configuration
- **Info.plist**: References configuration values

### API Configuration

Update `Config/Staging.xcconfig` to change the API endpoint:

```xcconfig
BASE_API_URL = https:\/\/your-api-endpoint.com
```

## Testing

The project includes unit tests for:
- View Controllers
- View Models
- Network Manager
- Repository Layer
- Data Sources

Run tests using `Cmd+U` in Xcode.

## Requirements

- iOS 13.0+
- Xcode 14.0+
- Swift 5.0+

