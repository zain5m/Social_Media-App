import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social/layout/cubit/social_cubit.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/shared/components/conditional_builder.dart';
import 'package:social/shared/network/remote/dio_helper.dart';
import 'package:social/shared/styles/icon_broken.dart';

import '../../main.dart';
import '../../shared/styles/colors.dart';

class ChatDetailsScreen extends StatelessWidget {
  final SocialUserModel? userReseverModel;
  final int? index;
  ChatDetailsScreen({this.userReseverModel, this.index});

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessages(receiverId: userReseverModel!.uId!);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userReseverModel!.image!),
                    radius: 20,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(userReseverModel!.name!),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var message = SocialCubit.get(context).messages[index];
                        if (SocialCubit.get(context).userModel!.uId ==
                            message.senderId) return buildMyMessage(message);
                        return buildMessage(message);
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15),
                      itemCount: SocialCubit.get(context).messages.length,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'type your massage here ...',
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          color: defaultColor,
                          child: MaterialButton(
                            onPressed: () {
                              if (messageController.text.isNotEmpty) {
                                SocialCubit.get(context).sendMessage(
                                  receiverId: userReseverModel!.uId,
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text,
                                );
                                SocialCubit.get(context).sendNotification(
                                  topicUid: userReseverModel!.uId,
                                  text: messageController.text,
                                  sender:
                                      SocialCubit.get(context).userModel!.name,
                                  resever: SocialCubit.get(context).userModel,
                                  // SocialCubit.get(context).users![index!],
                                );
                                messageController.clear();
                              }
                            },
                            minWidth: 1,
                            child: Icon(IconBroken.Send,
                                size: 16, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  buildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Text(model.text!),
        ),
      );

  buildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(0.2),
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Text(model.text!),
        ),
      );
}

// class buildMessage1 extends StatelessWidget {
//   MessageModel? model;
//   bool? isMe;
//   buildMessage1({this.model, this.isMe});
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 8,
//         vertical: 10,
//       ),
//       child: Align(
//         alignment: AlignmentDirectional.centerStart,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[300],
//             borderRadius: BorderRadiusDirectional.only(
//               bottomEnd: Radius.circular(10),
//               topEnd: Radius.circular(10),
//               topStart: Radius.circular(10),
//             ),
//           ),
//           padding: EdgeInsets.symmetric(
//             horizontal: 10,
//             vertical: 5,
//           ),
//           child: Text(model!.text!),
//         ),
//       ),
//     );
//   }
// }
