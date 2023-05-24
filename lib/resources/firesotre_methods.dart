import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    // from user
    String uid,
    String username,
    String profImage,

    // post
    String caption,
    Uint8List image,
  ) async {
    String res = "error";
    try {
      if (caption.isEmpty) {
        res = "Caption is empty";
      } else {
        String photoUrl = await StorageMethods()
            .uploadImageToStorage("posts", image, isPost: true);
        String postId = const Uuid().v1();

        Post post = Post(
          uid: uid,
          username: username,
          profImage: profImage,
          postId: postId,
          caption: caption,
          photoUrl: photoUrl,
          likes: [],
          createAt: DateTime.now(),
        );

        _firestore.collection("posts").doc(postId).set(post.toJson());

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<String> postComment(
    String postId,
    String uid,
    String username,
    String profImage,
    String text,
  ) async {
    String res = "Error";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        Comment comment = Comment(
            uid: uid,
            username: username,
            profImage: profImage,
            postId: postId,
            commentId: commentId,
            text: text,
            likes: [],
            createdAt: DateTime.now());
        _firestore
            .collection('posts')
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set(comment.toJson());
        res = "success";
      } else {
        res = "Field is requuired";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection("posts").doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser(
      String targetUid, String uid, List targetFollowers) async {
    try {
      if (targetFollowers.contains(uid)) {
        await _firestore.collection("users").doc(targetUid).update({
          "followers": FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayRemove([targetUid]),
        });
      } else {
        await _firestore.collection("users").doc(targetUid).update({
          "followers": FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayUnion([targetUid]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
