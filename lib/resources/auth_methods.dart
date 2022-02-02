import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('user').doc(currentUser.uid).get();
    return model.User.fromsnap(snap);
  }

  //sign up user

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        //add user to our database
        model.User user = model.User(
          bio: bio,
          username: username,
          uid: cred.user!.uid,
          email: email,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        await _firestore
            .collection('user')
            .doc(cred.user!.uid)
            .set(user.toJson());

        // another way of add user to data base
        // await _firestore.collection('user').add({
        //   'username' : username,
        //   'uid' : cred.user!.uid,
        //   'email' : email,
        //   'bio' : bio,
        //   'followers' : [],
        //   'following' : [],
        // });

        res = 'success';
      }
    }
    // on FirebaseAuthException catch(err){
    //   if(err.code == 'invalid-email'){
    //     res = 'the email bsdly formatted';
    //   }else if(err.code == 'weak-password'){
    //     res = 'password shold be al least 8 characters';
    //   }
    // }

    catch (err) {
      res = err.toString();
    }
    return res;
  }

  //login in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please Enter all the field';
      }
    }
    // on FirebaseAuthException catch (e){
    //   if(e.code == 'user-not-found'){
    //   }
    // }

    catch (err) {
      res = err.toString();
    }
    return res;
  }
}
