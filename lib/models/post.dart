import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String username;
  final String postId;
  final String caption;
  final String photoUrl;
  final String profImage;
  final List likes;
  final DateTime createAt;

  Post({
    required this.uid,
    required this.username,
    required this.postId,
    required this.caption,
    required this.photoUrl,
    required this.profImage,
    required this.likes,
    required this.createAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "postId": postId,
      "caption": caption,
      "photoUrl": photoUrl,
      "profImage": profImage,
      "likes": likes,
      "createdAt": createAt.toString(),
    };
  }

  factory Post.fromJson(DocumentSnapshot data) {
    var res = data.data() as Map<String, dynamic>;
    return Post(
        uid: res['uid'],
        username: res['username'],
        postId: res['postId'],
        caption: res['caption'],
        photoUrl: res['photoUrl'],
        profImage: res['profImage'],
        likes: res['likes'],
        createAt: DateTime.now());
  }
}
