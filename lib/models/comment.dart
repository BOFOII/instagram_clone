import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String uid;
  final String username;
  final String profImage;
  final String postId;
  final String commentId;
  final String text;
  final List likes;
  final DateTime createdAt;

  Comment({
    required this.uid,
    required this.username,
    required this.profImage,
    required this.postId,
    required this.commentId,
    required this.text,
    required this.likes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "profImage": profImage,
      "postId": postId,
      "commentId": commentId,
      "text": text,
      "likes": likes,
      "createdAt": createdAt.toString(),
    };
  }

  factory Comment.fromJson(DocumentSnapshot data) {
    var res = data.data() as Map<String, dynamic>;

    return Comment(
      uid: res['uid'],
      username: res['username'],
      profImage: res['profImage'],
      postId: res['postId'],
      commentId: res['commentId'],
      text: res['text'],
      likes: res['likes'],
      createdAt: res['createdAt'],
    );
  }
}
