import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final List followers;
  final List following;
  final String avatarUrl;

  User(
      {required this.uid,
      required this.username,
      required this.email,
      required this.bio,
      required this.followers,
      required this.following,
      required this.avatarUrl});

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "bio": bio,
      "followers": [],
      "following": [],
      "avatar": avatarUrl,
    };
  }

  factory User.fromJson(DocumentSnapshot data) {
    var jsonObj = data.data() as Map<String, dynamic>;

    return User(
        uid: jsonObj['uid'],
        username: jsonObj['username'],
        email: jsonObj['email'],
        bio: jsonObj['bio'],
        followers: jsonObj['followers'],
        following: jsonObj['following'],
        avatarUrl: jsonObj['avatar']);
  }
}
