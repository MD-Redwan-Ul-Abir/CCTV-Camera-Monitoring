import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skt_sikring/presentation/messaging/common/socket_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';
import '../../../infrastructure/utils/log_helper.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/networkImageFormating.dart';
import '../../shared/widgets/buttons/primary_buttons.dart';
import 'controllers/message_screen.controller.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final MessageScreenController messageScreenController = Get.find<MessageScreenController>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.h),
        child: AppBar(
          backgroundColor: AppColors.secondaryDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "Message",
            style: AppTextStyles.headLine6.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.primaryLight,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Obx(() {
        if (messageScreenController.isLoading.value ||
            messageScreenController.socketController.isConnecting.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryNormal),
          );
        }
        return RefreshIndicator(
          onRefresh: () => messageScreenController.getUserList(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Message',
                        style: AppTextStyles.headLine6.copyWith(height: 1.5),
                      ),
                      // PrimaryButton(onPressed: () {  }, text: 'Add User',height: 42.h,
                      //
                      // )
                      GestureDetector(
                        onTap: (){
    Get.toNamed(Routes.ADD_CONVERSATIONS);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            color: AppColors.primaryNormal,
                          ),
                          child: Center(child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
                            child: Text("Add User",style: AppTextStyles.caption1.copyWith(color: AppColors.secondaryLight),),
                          ),),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 10.h),

                  // Connection status indicator
                  Obx(() {
                    if (messageScreenController
                            .socketController
                            .socketStatus
                            .value ==
                        'error') {
                      return Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Connection failed. Tap to retry.',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  messageScreenController.retryConnection,
                              child: Text(
                                'Retry',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),

                  // Main content
                  Obx(() {
                    final chatItemList = messageScreenController.chatItemList;

                    print('List>>>>>>>>>>>>>${chatItemList.length}');

                    if (chatItemList.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.h),
                          child: Column(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No conversations yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Start a conversation to see it here',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Show conversation list
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: chatItemList.length,
                      itemBuilder: (context, index) {


                        final chatItem = chatItemList[index];

                        // Extract data from the model
                        final userName =
                            chatItem.userId?.name ?? 'Unknown User';
                        final lastMessage =
                            chatItem.conversations?.isNotEmpty == true
                                ? chatItem
                                        .conversations!
                                        .first
                                        .lastMessage
                                        ?.text ??
                                    'No messages'
                                : 'No messages';
                        final isOnline = chatItem.isOnline ?? false;
                        final dotColor =
                            isOnline
                                ? AppColors.greenNormal
                                : AppColors.redNormal;

                        return Card(
                          color: AppColors.secondaryDark,
                          elevation: 0,
                          margin: EdgeInsets.only(bottom: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Set up common controller data
                              messageScreenController
                                  .commonController
                                  .senderId
                                  .value = messageScreenController
                                      .userID;

                              messageScreenController
                                  .commonController
                                  .conversationId
                                  .value = chatItem
                                      .conversations!
                                      .first
                                      .conversationId!;

                              messageScreenController
                                  .commonController
                                  .userName
                                  .value = userName;
                              messageScreenController
                                  .commonController
                                  .token
                                  .value = messageScreenController
                                      .token;

                              messageScreenController
                                  .commonController
                                  .profileImage
                                  .value = ProfileImageHelper.formatImageUrl(
                                messageScreenController
                                    .chatItemList[index]
                                    .userId!
                                    .profileImage!
                                    .imageUrl,
                              );

                              // Notify controller about navigation to conversation
                              messageScreenController.leaveMessageScreen(
                                toScreen: 'ConversationPage',
                              );

                              // Navigate to conversation page
                              Get.toNamed(Routes.CONVERSATION_PAGE);
                            },
                            borderRadius: BorderRadius.circular(4.r),
                            splashColor: AppColors.grayDarker.withOpacity(
                              0.3,
                            ),
                            highlightColor: AppColors.grayDarker.withOpacity(
                              0.3,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w
                                ,
                                vertical: 12.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          50.r,
                                        ),
                                        child: Image.network(
                                          ProfileImageHelper.formatImageUrl(
                                            messageScreenController
                                                .chatItemList[index]
                                                .userId!
                                                .profileImage!
                                                .imageUrl,
                                          ),
                                          height: 64.h,
                                          width: 64.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.5,
                                              ),
                                              child: Text(
                                                userName,
                                                style: AppTextStyles.button
                                                    .copyWith(
                                                      color:
                                                          AppColors
                                                              .primaryLight,
                                                    ),
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              lastMessage,
                                              style: AppTextStyles.caption1
                                                  .copyWith(
                                                    color: Color(0xFFBAB8B9),
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            //"${messageScreenController.chatItemList[index].conversations?.first.updatedAt}",
                                         formatMessageTime("${messageScreenController.chatItemList[index].conversations?.first.updatedAt}" ?? ""),
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w400,
                                              height: 1.35,
                                              color: Color(0xFFD1DDEB).withOpacity(0.62),
                                            ),
                                          ),
                                          SizedBox(height: 12.h),
                                          Icon(
                                            Icons.circle,
                                            size: 10,
                                            color: dotColor,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
  String formatMessageTime(String timestamp) {
    try {

      DateTime messageTime = DateTime.parse(timestamp);
      DateTime now = DateTime.now();

      Duration difference = now.difference(messageTime);
      int minutesDifference = difference.inMinutes;


      String hour = messageTime.hour.toString().padLeft(2, '0');
      String minute = messageTime.minute.toString().padLeft(2, '0');


      if (minutesDifference < 5) {
        return "now";
      } else if (minutesDifference < 60) {
        return "$minute mins";
      }




      return "$hour:$minute";
    } catch (e) {

      return timestamp;
    }
  }
  @override
  void dispose() {
    // Handle disposal - this will be called when leaving the screen permanently
    messageScreenController.leaveMessageScreen();
    // messageScreenController.chatItemList.clear();
    // print(messageScreenController.chatItemList);
    super.dispose();
  }
}
