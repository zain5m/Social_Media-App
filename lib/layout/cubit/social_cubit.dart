import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/notification_model.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/modules/feeds/feeds_screen.dart';
import 'package:social/modules/new_post/new_post_screen.dart';
import 'package:social/shared/components/constants.dart';
import '../../models/comments_model.dart';
import '../../modules/chats/chats_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../modules/users/users_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../shared/network/remote/dio_helper.dart';

part 'social_state.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialStates());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;

// ! Get User Data
  void getUserData() {
    emit(SocialGetUserLoadingStates());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = SocialUserModel.fromJson(value.data());
      emit(SocialGetUserSuccessStates());
    }).catchError((e) {
      emit(SocialGetUserErrorStates(e.toString()));
    });
  }

// ! Change bottom Navigation Bar
  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titels = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    if (index == 1) {
      getAllUsers();
    }

    if (index == 2) {
      emit(SocialNewPostStates());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavStates());
    }
  }

// ! Image  profile

  final ImagePicker picker = ImagePicker();

  // * Get image picker for profile Image
  File? profileImage;
  Future<void> getProfileImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessStates());
    } else {
      print('No Image selected');
      emit(SocialProfileImagePickedErrorStates());
    }
  }

  //? Upload Data with Profile image
  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUploadLoadingStates());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadProfileImageSuccessStates());
        updateUser(name: name, phone: phone, bio: bio, image: value);
      }).catchError((onError) {
        emit(SocialUploadProfileImageErrorStates());
      });
    }).catchError((onError) {
      emit(SocialUploadProfileImageErrorStates());
    });
  }

  // *Get image picker for Cover Image
  File? coverImage;
  Future<void> getCoverImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessStates());
    } else {
      print('No Image selected');
      emit(SocialCoverImagePickedErrorStates());
    }
  }

  //? Upload Data  with Cover image
  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUploadLoadingStates());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //  emit(SocialUploadCoverImageSuccessStates());

        updateUser(name: name, phone: phone, bio: bio, cover: value);
      }).catchError((onError) {
        emit(SocialUploadCoverImageErrorStates());
      });
    }).catchError((onError) {
      emit(SocialUploadCoverImageErrorStates());
    });
  }

  // ? Upload All Data
  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      cover: cover ?? userModel!.cover,
      image: image ?? userModel!.image,
      uId: userModel!.uId,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((e) {
      emit(SocialUserUploadErrorStates());
    });
  }

// !Create post

  // *Get image picker for post Image
  File? postImage;
  Future<void> getPostImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessStates());
    } else {
      print('No Image selected');
      emit(SocialPostImagePickedErrorStates());
    }
  }

// *Remove post Image
  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageStates());
  }

  // ? Create Post With Upload Image
  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingStates());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        creatPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
      }).catchError((onError) {
        emit(SocialCreatePostErrorStates());
      });
    }).catchError((onError) {
      emit(SocialCreatePostErrorStates());
    });
  }

  // ? Create Post With Upload Image  OR  without Image
  void creatPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    PostModel model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessStates());
    }).catchError((e) {
      emit(SocialCreatePostErrorStates());
    });
  }

  // !Get All posts

  List<PostModel>? posts = [];
  List<String>? postsId = [];
  List<bool>? likes = [];
  List<int>? likeId = [];
  List<int>? commmentsId = [];
  List<CommentsModel>? commments = [];

  void getposts1() {
    emit(SocialGetPostsLoadingStates());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      posts = [];
      for (var elementPost in event.docs) {
        //*Get  postId
        postsId!.add(elementPost.id);
        //*Get post
        posts!.add(PostModel.fromJson(elementPost.data()));

        emit(SocialGetPostsSuccessStates());
      }
    });
  }

  // void getposts() {
  //   emit(SocialGetPostsLoadingStates());
  //   FirebaseFirestore.instance.collection('posts').get().then((valuePost) {
  //     valuePost.docs.forEach((elementPost) {
  //       // **********comments
  //       elementPost.reference.collection('comments').get().then((valueComment) {
  //         // *********commentsId
  //         commmentsId!.add(valueComment.docs.length);
  //         // emit(SocialGetCommentIdSuccessStates());
  //         valueComment.docs.forEach((elementComment) {
  //           // ********comments
  //           commments!.add(CommentsModel.fromJson(elementComment.data()));
  //           // emit(SocialGetCommentsSuccessStates());
  //         });
  //       }).catchError((e) {
  //         // emit(SocialGetCommentIdErrorStates(e));
  //       });
  //       //********** Like
  //       elementPost.reference.collection('likes').get().then((valueLike) {
  //         //****** LikesId
  //         likesId!.add(valueLike.docs.length);
  //         if (valueLike.docs.length > 0) {
  //           valueLike.docs.forEach((elementLike) {
  //             if (elementLike.id == userModel!.uId) {
  //               likes!.add(true);
  //             }
  //           });
  //         } else {
  //           likes!.add(false);
  //         }
  //         //****** PostsId
  //         postsId!.add(elementPost.id);
  //         //****** Posts
  //         posts!.add(PostModel.fromJson(elementPost.data()));
  //         emit(SocialGetLikeIdSuccessStates());
  //       }).catchError((error) {
  //         //   emit(SocialGetLikeIdErrorStates(error));
  //       });
  //     });
  //     emit(SocialGetPostsSuccessStates());
  //   }).catchError((e) {
  //     emit(SocialGetPostsErrorStates(e.toString()));
  //   });
  // }

  // ! Cearte Like
  void likePost({
    String? postId,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      "uId": userModel!.uId,
    }).then((value) {
      // posts!.removeAt(index!);
      emit(SocialLikePostSuccessStates());
    }).catchError((e) {
      print(e);
      emit(SocialLikePostErrorStates(e));
    });
  }

  //!Create Comment
  void commentPost({
    String? postId,
    String? text,
    String? dateTime,
  }) {
    CommentsModel model = CommentsModel(
      text: text,
      uId: userModel!.uId,
      image: userModel!.image,
      name: userModel!.name,
      dateTime: DateFormat.yMd().add_jms().format(DateTime.now()),
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
      emit(SocialCommentPostSuccessStates());
    }).catchError((e) {
      emit(SocialCommentPostErrorStates(e));
    });
  }

  //!get comments
  void getcommnents({
    required String postId,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection("comments")
        .orderBy("dateTime")
        .snapshots()
        .listen((event) {
      commments = [];
      for (var element in event.docs.reversed) {
        commments!.add(CommentsModel.fromJson(element.data()));
      }
      emit(SocialGetCommentsSuccessStates());
    });
  }

  // !Get All Users
  List<SocialUserModel>? users = [];
  void getAllUsers() {
    users = [];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uId'] != userModel!.uId) {
          users!.add(SocialUserModel.fromJson(element.data()));
        }
      }
      emit(SocialGetAllUserSuccessStates());
    }).catchError((e) {
      emit(SocialGetAllUserErrorStates(e.toString()));
    });
  }

  //!Send Notification

  void sendNotification({
    required String? topicUid,
    required String? text,
    required String? sender,
    required SocialUserModel? resever,
  }) {
    NotificationModel model = NotificationModel(
      to: "/topics/$topicUid",
      data: Data(
        text: text,
        sender: userModel!.name,
        resever: resever,
      ),
    );
    DioHelper.postData(data: model.toJson()).then((value) {
      print(value);
    }).catchError((e) {});
  }

  //!Messages
  void sendMessage({
    required String? receiverId,
    required String? dateTime,
    required String? text,
  }) {
    MessageModel model = MessageModel(
      receiverId: receiverId,
      dateTime: dateTime,
      senderId: userModel!.uId,
      text: text,
    );
    //? set my chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessStates());
    }).catchError((e) {
      emit(SocialSendMessageErrorStates());
    });
    //? set receiver chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessStates());
    }).catchError((e) {
      emit(SocialSendMessageErrorStates());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs.reversed) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(SocialGetMessageSuccessStates());
    });
  }
}
