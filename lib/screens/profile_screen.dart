import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firesotre_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/widgets/follow_button.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user.dart' as model;

class ProfileScreen extends StatefulWidget {
  final String? uid;

  const ProfileScreen({super.key, this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  model.User? _userData;
  int _post = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      var data = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid ?? FirebaseAuth.instance.currentUser!.uid)
          .get();
      _userData = model.User.fromJson(data);

      var dataPost = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid",
              isEqualTo: widget.uid ?? FirebaseAuth.instance.currentUser!.uid)
          .get();

      _post = dataPost.docs.length;
      setState(() {
        _isLoading = false;
      });
    } catch (err) {}
  }

  void followUser() async {
    await FirestoreMethods().followUser(_userData!.uid,
        FirebaseAuth.instance.currentUser!.uid, _userData!.followers);
  }

  FollowButton buildButton() {
    if (widget.uid == null ||
        FirebaseAuth.instance.currentUser!.uid == widget.uid) {
      return FollowButton(
          function: () {
            AuthMethods().signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
          },
          backgroundColor: webBackgroundColor,
          borderColor: Colors.grey,
          text: "Sign out",
          textColor: primaryColor);
    }

    if (_userData!.followers.contains(FirebaseAuth.instance.currentUser!.uid)) {
      return FollowButton(
          function: followUser,
          backgroundColor: Colors.blue,
          borderColor: Colors.blue,
          text: "Followed",
          textColor: primaryColor);
    }
    return FollowButton(
        function: followUser,
        backgroundColor: Colors.blue,
        borderColor: Colors.blue,
        text: "Follow",
        textColor: primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(color: primaryColor),
          )
        : Scaffold(
            backgroundColor: width > webScreenSize
                ? webBackgroundColor
                : mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(_userData!.username),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(_userData!.avatarUrl),
                            radius: 40,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildColumn("Posts", _post),
                                    buildColumn("Followers",
                                        _userData!.followers.length),
                                    buildColumn("Following",
                                        _userData!.following.length),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [buildButton()],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          _userData!.username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          _userData!.bio,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("posts")
                      .where("uid",
                          isEqualTo: widget.uid ??
                              FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  snapshot.data!.docs[index]['photoUrl'])),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildColumn(String label, int num) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
