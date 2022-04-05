import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:social/layout/cubit/social_cubit.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/modules/chat_details/chat_details_screen.dart';
import 'package:social/modules/new_post/new_post_screen.dart';
import 'package:social/shared/styles/icon_broken.dart';

import '../main.dart';
import '../shared/components/components.dart';
import '../shared/network/local/local_notifications.dart';

class SocialLayout extends StatefulWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  State<SocialLayout> createState() => _SocialLayoutState();
}

class _SocialLayoutState extends State<SocialLayout> {
  @override
  void initState() {
    super.initState();
    LocalNotifications.initialze(context);

    //?gives you the message on which user taps
    //?and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {});

    FirebaseMessaging.onMessage.listen((message) {});
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostStates) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewPostScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var model = SocialCubit.get(context).userModel;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titels[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(IconBroken.Notification),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(IconBroken.Search),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Chat),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Paper_Upload),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Location),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Setting),
                label: 'Settings',
              ),
            ],
          ),
          // body: model != null
          //     ? Column(
          //         children: [
          //           if (!FirebaseAuth.instance.currentUser!.emailVerified)
          //             Container(
          //               color: Colors.amber.withOpacity(.6),
          //               child: Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //                 child: Row(
          //                   children: [
          //                     Icon(
          //                       Icons.info_outline,
          //                     ),
          //                     SizedBox(
          //                       width: 15.0,
          //                     ),
          //                     Expanded(
          //                       child: Text(
          //                         'pleas verify your email',
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       width: 20.0,
          //                     ),
          //                     defaultTextButton(
          //                       function: () {
          //                         FirebaseAuth.instance.currentUser!
          //                             .sendEmailVerification()
          //                             .then((value) {
          //                           showToast(
          //                               text: 'check your mail',
          //                               state: ToastState.SUCCESS);
          //                         }).catchError((e) {});
          //                       },
          //                       text: 'send',
          //                     )
          //                   ],
          //                 ),
          //               ),
          //             ),
          //         ],
          //       )
          //     : Center(
          //         child: CircularProgressIndicator(),
          //       ),
        );
      },
    );
  }
}
