import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/social_cubit.dart';
import 'package:social/models/comments_model.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';

class CommentsScreeen extends StatelessWidget {
  const CommentsScreeen({
    this.postId,
    this.indexPost,
    this.countLike,
    this.mylike,
  });
  final String? postId;
  final int? indexPost;
  final int? countLike;
  final bool? mylike;

  @override
  Widget build(BuildContext context) {
    var commentControler = TextEditingController();
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getcommnents(postId: postId!);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.97,
              builder: (context, scrollController) => Container(
                padding: const EdgeInsetsDirectional.only(top: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("$countLike"),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            IconBroken.Heart,
                            color: mylike! ? Colors.black : Colors.red,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        reverse: true,
                        itemBuilder: (context, index) => buildCommentItem(
                            SocialCubit.get(context).commments![index],
                            context),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 5),
                        itemCount: SocialCubit.get(context).commments!.length,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                    Material(
                      color: Colors.white,
                      elevation: 10,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: commentControler,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    fillColor: Colors.black.withOpacity(0.1),
                                    filled: true,
                                    hintText: 'Write comment ...',
                                    hintStyle: const TextStyle(
                                      height: 0.7,
                                      fontSize: 15,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).commentPost(
                                    postId: postId!,
                                    text: commentControler.text,
                                  );
                                  commentControler.clear();
                                },
                                icon: const Icon(
                                  IconBroken.Send,
                                  color: defaultColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget buildCommentItem(CommentsModel? model, context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('${model!.image}'),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(.1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${model.text}',
                      // 'socialsocialsocialsocialsocialsocialsocialsocialsocialsocialsocialsocialsocialsocialsocialsocialsocialsocialsocialss',
                      maxLines: double.infinity.hashCode,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
