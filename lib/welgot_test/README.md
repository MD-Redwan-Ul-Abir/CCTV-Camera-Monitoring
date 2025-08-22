# Weglot Translation Test

This folder contains a complete test implementation for the Weglot translation API in Flutter.

## Files Structure

```
welgot_test/
├── services/
│   └── welgot_service.dart     # Service class for Weglot API integration
├── screens/
│   └── welgot_test_screen.dart # Flutter UI screen for testing translations
├── welgot_test_app.dart        # Standalone Flutter app for testing
├── test_welgot.dart           # Command line test script
└── README.md                  # This file
```

## API Key

Your Weglot API key: `wg_2eff789aedd6e4dfc8bd2f1f722feea46`

## Test Results

✅ **API Connection: SUCCESS**  
✅ **English to Bangla Translation: WORKING**

### Sample Translations:
- "Hello" → "হ্যালো"
- "Good morning" → "শুভ সকাল"
- "How are you?" → "তুমি কেমন আছো?"
- "Thank you very much" → "অনেক ধন্যবাদ।"
- "Welcome to Bangladesh" → "বাংলাদেশে স্বাগতম।"

## How to Use

### 1. Command Line Testing
```bash
cd your_project_root
dart lib/welgot_test/test_welgot.dart
```

### 2. Flutter App Testing
Run the standalone test app:
```bash
cd your_project_root
flutter run lib/welgot_test/welgot_test_app.dart
```

### 3. Integration in Your Main App
Import and use the service:
```dart
import 'package:skt_sikring/welgot_test/services/welgot_service.dart';

// Translate text
String translated = await WelgotService.translateText("Hello", from: 'en', to: 'bn');
print(translated); // Output: হ্যালো
```

## API Details

- **Service**: Weglot Translation API
- **Endpoint**: `https://api.weglot.com/translate`
- **Supported Languages**: English (en) ↔ Bangla (bn)
- **Rate Limits**: Check your Weglot plan for API rate limits

## Features

- ✅ Connection testing
- ✅ Real-time translation
- ✅ Error handling
- ✅ Flutter UI with quick test examples
- ✅ Command line testing capability