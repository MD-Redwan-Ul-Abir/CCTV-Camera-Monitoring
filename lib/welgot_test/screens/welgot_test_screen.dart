// import 'package:flutter/material.dart';
// import '../services/welgot_service.dart';
//
// class WelgotTestScreen extends StatefulWidget {
//   const WelgotTestScreen({Key? key}) : super(key: key);
//
//   @override
//   State<WelgotTestScreen> createState() => _WelgotTestScreenState();
// }
//
// class _WelgotTestScreenState extends State<WelgotTestScreen> {
//   final TextEditingController _inputController = TextEditingController();
//   String _translatedText = '';
//   bool _isLoading = false;
//   bool _connectionTested = false;
//   bool _isConnected = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _testConnection();
//   }
//
//   Future<void> _testConnection() async {
//     setState(() => _isLoading = true);
//     final isConnected = await WelgotService.testConnection();
//     setState(() {
//       _connectionTested = true;
//       _isConnected = isConnected;
//       _isLoading = false;
//     });
//   }
//
//   Future<void> _translateText() async {
//     if (_inputController.text.isEmpty) return;
//
//     setState(() => _isLoading = true);
//
//     final translated = await WelgotService.translateText(
//       _inputController.text,
//       from: 'en',
//       to: 'bn',
//     );
//
//     setState(() {
//       _translatedText = translated;
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Welgot Translation Test'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Connection Status
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: _connectionTested
//                     ? (_isConnected ? Colors.green.shade100 : Colors.red.shade100)
//                     : Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: _connectionTested
//                       ? (_isConnected ? Colors.green : Colors.red)
//                       : Colors.grey,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     _connectionTested
//                         ? (_isConnected ? Icons.check_circle : Icons.error)
//                         : Icons.hourglass_empty,
//                     color: _connectionTested
//                         ? (_isConnected ? Colors.green : Colors.red)
//                         : Colors.grey,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     _connectionTested
//                         ? (_isConnected ? 'Welgot API Connected' : 'Connection Failed')
//                         : 'Testing Connection...',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: _connectionTested
//                           ? (_isConnected ? Colors.green : Colors.red)
//                           : Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Input Field
//             TextField(
//               controller: _inputController,
//               decoration: const InputDecoration(
//                 labelText: 'Enter English text',
//                 hintText: 'Type something in English...',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//
//             const SizedBox(height: 16),
//
//             // Translate Button
//             ElevatedButton(
//               onPressed: _isLoading ? null : _translateText,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//               child: _isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text(
//                       'Translate to Bangla',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Translation Result
//             if (_translatedText.isNotEmpty) ...[
//               const Text(
//                 'Translation:',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: Text(
//                   _translatedText,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//
//             const SizedBox(height: 20),
//
//             // Test Examples
//             const Text(
//               'Quick Test Examples:',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               children: [
//                 _buildQuickTestButton('Hello'),
//                 _buildQuickTestButton('Good morning'),
//                 _buildQuickTestButton('How are you?'),
//                 _buildQuickTestButton('Thank you'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuickTestButton(String text) {
//     return ElevatedButton(
//       onPressed: _isLoading
//           ? null
//           : () {
//               _inputController.text = text;
//               _translateText();
//             },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.grey.shade200,
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(color: Colors.black87),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _inputController.dispose();
//     super.dispose();
//   }
// }