import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchEditingController =
      TextEditingController();

  bool _showUser = false;

  @override
  void dispose() {
    super.dispose();
    _searchEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextField(
          controller: _searchEditingController,
          decoration: const InputDecoration(
            hintText: "Search",
            border: InputBorder.none,
          ),
          onSubmitted: (_) {
            setState(() {
              _showUser = true;
            });
          },
        ),
      ),
      body: _showUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .where("username",
                      isGreaterThanOrEqualTo: _searchEditingController.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // if (snapshot.data!.docs.length < 1) {
                //   print(snapshot.data!.docs.length);
                //   return Container();
                // }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                            uid: snapshot.data!.docs[index]['uid']),
                      ));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data!.docs[index]['avatar']),
                      ),
                      title: Text(snapshot.data!.docs[index]['username']),
                    ),
                  ),
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection("posts").get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => Image(
                      fit: BoxFit.fill,
                      image:
                          NetworkImage(snapshot.data!.docs[index]['photoUrl'])),
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                    (index % 7 == 0 ? 2 : 1),
                    (index % 7 == 0 ? 2 : 1),
                  ),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                );
              },
            ),
    );
  }
}
