part of 'social_cubit.dart';

@immutable
abstract class SocialStates {}

class SocialInitialStates extends SocialStates {}

// !Get user
class SocialGetUserLoadingStates extends SocialStates {}

class SocialGetUserSuccessStates extends SocialStates {}

class SocialGetUserErrorStates extends SocialStates {
  final String error;
  SocialGetUserErrorStates(this.error);
}

// !Get All user
class SocialGetAllUserLoadingStates extends SocialStates {}

class SocialGetAllUserSuccessStates extends SocialStates {}

class SocialGetAllUserErrorStates extends SocialStates {
  final String error;
  SocialGetAllUserErrorStates(this.error);
}

//  !change Botton
class SocialChangeBottomNavStates extends SocialStates {}

// ?change Button for new post
class SocialNewPostStates extends SocialStates {}

// !Get image picker for profile
class SocialProfileImagePickedSuccessStates extends SocialStates {}

class SocialProfileImagePickedErrorStates extends SocialStates {}

// !Get image picker for Cover
class SocialCoverImagePickedSuccessStates extends SocialStates {}

class SocialCoverImagePickedErrorStates extends SocialStates {}

// !Upload image picker for profile
class SocialUploadProfileImageSuccessStates extends SocialStates {}

class SocialUploadProfileImageErrorStates extends SocialStates {}

// !Upload image picker for Cover
class SocialUploadCoverImageSuccessStates extends SocialStates {}

class SocialUploadCoverImageErrorStates extends SocialStates {}

// !for upload user Data image && cover && Data
class SocialUserUploadLoadingStates extends SocialStates {}

class SocialUserUploadErrorStates extends SocialStates {}

// !create post

class SocialCreatePostLoadingStates extends SocialStates {}

class SocialCreatePostSuccessStates extends SocialStates {}

class SocialCreatePostErrorStates extends SocialStates {}

// ?Get image picker for post Image
class SocialPostImagePickedSuccessStates extends SocialStates {}

class SocialPostImagePickedErrorStates extends SocialStates {}

// ?Remove Post  Image
class SocialRemovePostImageStates extends SocialStates {}

// !Get All posts
class SocialGetPostsLoadingStates extends SocialStates {}

class SocialGetPostsSuccessStates extends SocialStates {}

class SocialGetPostsErrorStates extends SocialStates {
  final String error;
  SocialGetPostsErrorStates(this.error);
}

// !Create Likes

class SocialLikePostSuccessStates extends SocialStates {}

class SocialLikePostErrorStates extends SocialStates {
  final String error;
  SocialLikePostErrorStates(this.error);
}
// !Get LikesId

class SocialGetLikeIdSuccessStates extends SocialStates {}

class SocialGetLikeIdErrorStates extends SocialStates {
  final String error;
  SocialGetLikeIdErrorStates(this.error);
}

// !Create Comment

class SocialCommentPostSuccessStates extends SocialStates {}

class SocialCommentPostErrorStates extends SocialStates {
  final String error;
  SocialCommentPostErrorStates(this.error);
}

// !Get CommentId && commments

class SocialGetCommentIdSuccessStates extends SocialStates {}

class SocialGetCommentsSuccessStates extends SocialStates {}

class SocialGetCommentIdErrorStates extends SocialStates {
  final String error;
  SocialGetCommentIdErrorStates(this.error);
}

// !Get && Send message

class SocialSendMessageSuccessStates extends SocialStates {}

class SocialSendMessageErrorStates extends SocialStates {}

class SocialGetMessageSuccessStates extends SocialStates {}

class SocialGetMessageErrorStates extends SocialStates {}

class e extends SocialStates {}
