import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/social_cubit.dart';
import 'package:social/layout/social_layout.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/modules/chat_details/chat_details_screen.dart';
import 'package:social/modules/settings/settings_screen.dart';
import 'package:social/modules/social_login/social_login_screen.dart';
import 'package:social/modules/users/users_screen.dart';
import 'package:social/shared/bloc_observer.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/network/local/cach_helper.dart';
import 'package:social/shared/network/local/local_notifications.dart';
import 'package:social/shared/network/remote/dio_helper.dart';
import 'firebase_options.dart';

import 'shared/styles/themes.dart';

/*
! Platform  Firebase App Id
? android  1:747061229011:android:64b76a21a6ad625db22b26
*/
//Global Initialization

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  LocalNotifications.display(message);
}

void main() async {
  // runApp(MyApp());
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      DioHelper.init();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      var token = await FirebaseMessaging.instance.getToken();
      print(token);

// ! foreground fcm
      // FirebaseMessaging.onMessage.listen((event) {
      //   RemoteNotification notification = event.notification!;
      //   AndroidNotification? android = event.notification?.android;

      //   print(event.notification!);
      //   print(event.notification?.android);

      //   print('ssssssssssss');
      //   print(event.data);
      //   showToast(text: 'onMessage', state: ToastState.SUCCESS);
      // });
      //! whrn click on notification to open app
      // FirebaseMessaging.onMessageOpenedApp.listen((event) {
      //   toast('Hello world!');

      //   // show a notification at top of screen.
      //   showSimpleNotification(
      //       Text("this is a message from simple notification"),
      //       background: Colors.green);
      //   showToast(text: 'onMessage Opened App', state: ToastState.SUCCESS);
      //   print('onMessage Opened App');
      //   print(event.data.toString());
      // });

//! on Background FCM
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await CacheHelper.init();
      Widget widget;
      uId = CacheHelper.getData(key: 'uId');

      if (uId != null) {
        widget = const SocialLayout();
      } else {
        widget = SocialLoginScreen();
      }
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;
  const MyApp({this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()
        ..getUserData()
        ..getposts1()
        ..getAllUsers(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}
