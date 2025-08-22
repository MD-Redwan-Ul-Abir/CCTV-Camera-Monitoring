import 'dart:io';
import 'services/welgot_service.dart';

void main() async {
  print('Testing Welgot API...');
  
  // Test connection
  print('\n1. Testing connection...');
  bool isConnected = await WelgotService.testConnection();
  print('Connection status: ${isConnected ? 'SUCCESS' : 'FAILED'}');
  
  // Test basic translations
  print('\n2. Testing translations...');
  
  List<String> testTexts = [
    'Current password',
    'New Password',
    'Confirm New Password',
    'Thank you very much',
    'Imtiaz is a good boy'
  ];
  
  for (String text in testTexts) {
    print('\nTranslating: "$text"');
    String translated = await WelgotService.translateText(text);
    print('Result: "$translated"');
  }
  
  print('\n✅ Welgot API test completed!');
}