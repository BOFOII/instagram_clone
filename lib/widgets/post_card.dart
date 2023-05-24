import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firesotre_methods.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isAnimating = false;

  void navigateToComment() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CommentScreen(
        postId: widget.snap['postId'],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: width > webScreenSize
                  ? secondaryColor
                  : mobileBackgroundColor),
          color: mobileBackgroundColor),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Column(
        children: [
          // header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap["profImage"]),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: [
                              widget.snap['uid'] == user!.uid
                                  ? InkWell(
                                      onTap: () async {
                                        await FirestoreMethods()
                                            .deletePost(widget.snap['postId']);
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 10,
                                          ),
                                          child: const Text("Delete")),
                                    )
                                  : Container(),
                            ],
                            // children: [
                            //   "Delete",
                            // ]
                            //     .map(
                            //       (e) => InkWell(
                            //         onTap: () {},
                            //         child: Container(
                            //             padding: const EdgeInsets.symmetric(
                            //               vertical: 12,
                            //               horizontal: 10,
                            //             ),
                            //             child: Text(e)),
                            //       ),
                            //     )
                            //     .toList(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          // image
          GestureDetector(
            onDoubleTap: () {
              FirestoreMethods().likePost(
                widget.snap['postId'],
                user!.uid,
                widget.snap['likes'],
              );
              setState(() {
                _isAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(widget.snap["photoUrl"]),
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: _isAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        _isAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                )
              ],
            ),
          ),

          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user!.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () {
                    FirestoreMethods().likePost(
                      widget.snap['postId'],
                      user.uid,
                      widget.snap['likes'],
                    );
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              IconButton(
                onPressed: navigateToComment,
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_outline),
                  ),
                ),
              )
            ],
          ),
          // DESC
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    "${widget.snap['likes'].length.toString()} Likes",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: " ${widget.snap['caption']}",
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: navigateToComment,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("posts")
                          .doc(widget.snap['postId'])
                          .collection("comments")
                          .orderBy("createdAt", descending: true)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("View all 0 comments");
                        }
                        return Text(
                            "View all ${snapshot.data!.docs.length} comments");
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    widget.snap['createdAt'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: secondaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
