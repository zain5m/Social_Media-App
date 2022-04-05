import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/social_cubit.dart';
import 'package:social/models/post_model.dart';
import 'package:social/modules/comment/comment_screen.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';
import '../../shared/components/conditional_builder.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getposts1();

      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return ConditionalBuilder(
            condition: SocialCubit.get(context).postsId!.isNotEmpty &&
                SocialCubit.get(context).userModel != null,
            builder: (context) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(8),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        const Image(
                          image: NetworkImage(
                              'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg'),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'commmunicate with friends',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => buildPostItem(
                      model: SocialCubit.get(context).posts![index],
                      // like: true,
                      // like: SocialCubit.get(context).likes?[index],
                      context: context,
                      index: index,
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                    itemCount: SocialCubit.get(context).posts!.length,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    });
  }

  Widget buildPostItem({required PostModel model, context, index}) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(SocialCubit.get(context).postsId![index])
            .collection('likes')
            .snapshots(),
        builder: (context, snapshotlike) {
          if (snapshotlike.hasData) {
            int countLike = snapshotlike.data!.docs.length;
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 8),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage('${model.image}'),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${model.name}',
                                    style: const TextStyle(
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  const Icon(
                                    Icons.check_circle,
                                    size: 16.0,
                                    color: defaultColor,
                                  ),
                                ],
                              ),
                              Text(
                                '${model.dateTime}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      height: 1.4,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz, size: 16.0),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ),
                    Text(
                      '${model.text}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          bottom: 10, top: 5.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                end: 6,
                              ),
                              child: SizedBox(
                                height: 25.0,
                                child: MaterialButton(
                                  onPressed: () {},
                                  minWidth: 1.0,
                                  padding: EdgeInsets.zero,
                                  child: Text(
                                    '#sofrware',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          color: defaultColor,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                end: 6,
                              ),
                              child: SizedBox(
                                height: 25.0,
                                child: MaterialButton(
                                  onPressed: () {},
                                  minWidth: 1.0,
                                  padding: EdgeInsets.zero,
                                  child: Text(
                                    '#sofrware',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          color: defaultColor,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (model.postImage != '')
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top: 15),
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                '${model.postImage}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(SocialCubit.get(context).postsId![index])
                            .collection('likes')
                            .where('uId',
                                isEqualTo:
                                    SocialCubit.get(context).userModel!.uId)
                            .snapshots(),
                        builder: (context, snapshotMyLike) {
                          if (snapshotMyLike.hasData) {
                            return Wrap(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  IconBroken.Heart,
                                                  size: 16,
                                                  color: snapshotMyLike
                                                          .data!.docs.isEmpty
                                                      ? Colors.black
                                                      : Colors.red,
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  '$countLike',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Icon(
                                                  IconBroken.Chat,
                                                  size: 16,
                                                  color: Colors.amber,
                                                ),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('posts')
                                                      .doc(SocialCubit.get(
                                                              context)
                                                          .postsId![index])
                                                      .collection("comments")
                                                      .orderBy("dateTime")
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    return Text(
                                                      snapshot.hasData
                                                          ? '${snapshot.data?.docs.length} comment '
                                                          : '0 comment ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption,
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    width: double.infinity,
                                    height: 1.0,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundImage: NetworkImage(
                                                  '${SocialCubit.get(context).userModel!.image}'),
                                            ),
                                            const SizedBox(
                                              width: 15.0,
                                            ),
                                            Text(
                                              'write a comment ....',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                      // height: 1.4,
                                                      ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(30),
                                              ),
                                            ),
                                            builder: (context) =>
                                                CommentsScreeen(
                                              postId: SocialCubit.get(context)
                                                  .postsId![index],
                                              indexPost: index,
                                              countLike: countLike,
                                              mylike: snapshotMyLike
                                                  .data!.docs.isEmpty,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Icon(
                                            IconBroken.Heart,
                                            size: 16,
                                            color: snapshotMyLike
                                                    .data!.docs.isEmpty
                                                ? Colors.black
                                                : Colors.red,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            'Like',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        if (snapshotMyLike.data!.docs.isEmpty) {
                                          SocialCubit.get(context).likePost(
                                            postId: SocialCubit.get(context)
                                                .postsId![index],
                                          );
                                        } else {
                                          FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(SocialCubit.get(context)
                                                  .postsId![index])
                                              .collection('likes')
                                              .doc(SocialCubit.get(context)
                                                  .userModel!
                                                  .uId)
                                              .delete();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                          return const Center();
                        }),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: SingleChildScrollView(),
          );
        });
  }
}
