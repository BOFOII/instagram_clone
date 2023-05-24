import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firesotre_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _commentEditingController.dispose();
  }

  postComment(
    String uid,
    String username,
    String profImage,
    String text,
  ) async {
    String res = await FirestoreMethods()
        .postComment(widget.postId, uid, username, profImage, text);

    if (res == "success") {
      showSnackBar(
          const Text(
            "Comment created",
            style: TextStyle(color: blueColor),
          ),
          context);
    } else {
      showSnackBar(
          Text(
            res,
            style: TextStyle(color: Colors.red),
          ),
          context);
    }

    _commentEditingController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return user == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: width > webScreenSize
                ? webBackgroundColor
                : mobileBackgroundColor,
            appBar: AppBar(
              title: const Text('Comments'),
              centerTitle: false,
              backgroundColor: mobileBackgroundColor,
              // actions: [IconButton(onPressed: () {}, icon: Icon())],
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(widget.postId)
                  .collection("comments")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => CommentCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
              },
              // child: ListView(
              //   children: [
              //     CommentCard(),
              //     CommentCard(),
              //     CommentCard(),
              //   ],
              // ),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                height: kToolbarHeight,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user!.avatarUrl),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8.0),
                      child: TextField(
                        controller: _commentEditingController,
                        decoration: const InputDecoration(
                            hintText: "Add a comment",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => postComment(user.uid, user.username,
                        user.avatarUrl, _commentEditingController.text),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: const Text(
                        "Post",
                        style: TextStyle(color: blueColor),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          );
  }
}
