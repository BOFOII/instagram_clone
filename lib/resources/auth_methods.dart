import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthMethods() {}

  Future<model.User> getDetailUser() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();
    return model.User.fromJson(snap);
  }

  Future<String> signUpUser(String username, String bio, String email,
      String password, Uint8List image) async {
    String res = "Field is required";

    try {
      if (username.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty) {
        // add to auth
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String avatarUrl =
            await StorageMethods().uploadImageToStorage("users", image);

        String uid = credential.user!.uid;

        model.User user = model.User(
            uid: uid,
            username: username,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            avatarUrl: avatarUrl);

        // print(user.toJson());

        // add to another database
        await _firestore.collection("users").doc(uid).set(user.toJson());

        res = "success";

        print(
            "============================================================================");
        print("SUCCESS");
      }
    } on FirebaseAuthException catch (error) {
      res = error.code.replaceAll("-", " ");
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> siginUser(String email, String password) async {
    String res = "Field is required";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential credential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = "success";
      }
    } on FirebaseAuthException catch (error) {
      res = error.code.replaceAll("-", " ");
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
