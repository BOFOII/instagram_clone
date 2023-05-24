import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firesotre_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _image;
  bool _isLoading = false;

  final TextEditingController _captionEditingController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _captionEditingController.dispose();
  }

  postImage(String uid, String username, String profileImage) async {
    try {
      setState(() {
        _isLoading = true;
      });

      String res = await FirestoreMethods().uploadPost(
        uid,
        username,
        profileImage,
        _captionEditingController.text,
        _image!,
      );

      if (res == "success") {
        showSnackBar(
            const Text(
              "Post created",
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
            context);

        setState(() {
          _image = null;
        });
      } else {
        showSnackBar(
            Text(
              res,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            context);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      showSnackBar(
          Text(
            error.toString(),
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    if (_image == null) {
      return Center(
        child: IconButton(
            onPressed: () async {
              Uint8List? file = await imagePicker(ImageSource.gallery);
              setState(() {
                _image = file;
              });
            },
            icon: const Icon(Icons.upload)),
      );
    }
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
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _image = null;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text("New post"),
              actions: [
                IconButton(
                  onPressed: () =>
                      postImage(user!.uid, user.username, user.avatarUrl),
                  icon: const Icon(
                    Icons.check,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator(
                        color: primaryColor,
                      )
                    : Container(),
                Container(
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_image!),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextField(
                          controller: _captionEditingController,
                          decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none,
                          ),
                          maxLines: 8,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
