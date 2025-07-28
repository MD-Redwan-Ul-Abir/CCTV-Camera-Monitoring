import 'package:get/get.dart';

class MessageScreenController extends GetxController {
  //TODO: Implement MessageScreenController

  final count = 0.obs;
  List<Map<String, String>> messageList = [
    {'name': 'Mila Tanaka(Admin)', 'time': '9:45 AM','message':'Meeting Schedule','status':'inactive'},
    {'name': 'Mila Tanaka(Security Employee)', 'time': '10:25 AM','message':'Project Update','status':'inactive'},
    {'name': 'Bobs', 'time': '3:50 AM','message':'Budget Review','status':'active'},
  ];


  void increment() => count.value++;
}
