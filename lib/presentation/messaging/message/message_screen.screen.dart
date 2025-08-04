import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';
import '../../../infrastructure/utils/app_images.dart';

import '../../shared/networkImageFormating.dart';
import 'controllers/message_screen.controller.dart';
import 'model/conversationListModel.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final MessageScreenController messageScreenController =
      Get.find<MessageScreenController>();

  @override
  void initState() {
    super.initState();
    messageScreenController.connectAndFetchData();
    // if(messageScreenController.isSocketConnected==true){
    //   messageScreenController.getUserList();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //
      //
      //     messageScreenController.getUserList();
      //
      // }),
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
      body: RefreshIndicator(
        onRefresh: () async {
          messageScreenController.getUserList();
        },
        child: Obx(() {
          if (messageScreenController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryNormal),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Message',
                      style: AppTextStyles.headLine6.copyWith(height: 1.5),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Connection status indicator

                  // Main content
                  Obx(() {
                    final chatItemList = messageScreenController.chatItemList;
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
                              messageScreenController
                                  .commonController
                                  .senderId
                                  .value = messageScreenController.myID!.value;

                              messageScreenController
                                      .commonController
                                      .conversationId
                                      .value =
                                  chatItem.conversations!.first.conversationId!;

                              messageScreenController
                                  .commonController
                                  .userName
                                  .value = userName;
                              messageScreenController
                                  .commonController
                                  .token
                                  .value = messageScreenController.token.value;

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

                              Get.toNamed(Routes.CONVERSATION_PAGE);
                            },
                            borderRadius: BorderRadius.circular(4.r),
                            splashColor: AppColors.grayDarker.withOpacity(0.3),
                            highlightColor: AppColors.grayDarker.withOpacity(
                              0.3,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
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
                                                overflow: TextOverflow.ellipsis,
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
                                            'Now',
                                            // You can format the actual timestamp here
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w400,
                                              height: 1.35,
                                              color: Color(
                                                0xFFD1DDEB,
                                              ).withOpacity(0.62),
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
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    // messageScreenController.chatItemList = <AllConversationList>[].obs;
    messageScreenController.socket?.disconnect();

    messageScreenController.socket?.dispose();

    print(messageScreenController.chatItemList);

    super.dispose();
  }
}
