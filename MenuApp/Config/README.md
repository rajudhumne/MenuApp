# Configuration

This directory contains configuration files for different environments.

## Files

- **AppConfig.swift**: Configuration manager for accessing environment variables
- **Staging.xcconfig**: Staging environment configuration

## Usage

### AppConfig

Access configuration values using the `AppConfig` class:

```swift
let baseUrl: String = AppConfig.value(for: .baseApiUrl)
```

### Adding New Configuration Values

1. Add the key to `AppConfig.Key` enum:
```swift
enum Key: String {
    case baseApiUrl = "BASE_API_URL"
    case newKey = "NEW_KEY"
}
```

2. Add the value to `Staging.xcconfig`:
```xcconfig
NEW_KEY = "your_value_here"
```

3. Add the value to `Info.plist`:
```xml
<key>NEW_KEY</key>
<string>$(NEW_KEY)</string>
```
