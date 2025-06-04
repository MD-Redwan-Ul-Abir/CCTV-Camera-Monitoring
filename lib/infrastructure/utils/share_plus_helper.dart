import 'package:share_plus/share_plus.dart';

class ShareHelper {
  // Share text
  static void shareText(String text) {
    Share.share(text);
  }

  // Share text with subject (for email clients)
  static void shareWithSubject(String text, String subject) {
    Share.share(text, subject: subject);
  }

  // Share files
  static void shareFiles(List<String> filePaths, String text) async {
    final files = filePaths.map((path) => XFile(path)).toList();
    await Share.shareXFiles(files, text: text);
  }
}
