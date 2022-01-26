import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

       String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        //add user to our database
        await _firestore.collection('user').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl':photoUrl,
        });

        // another way of add user to data base
        // await _firestore.collection('user').add({
        //   'username' : username,
        //   'uid' : cred.user!.uid,
        //   'email' : email,
        //   'bio' : bio,
        //   'followers' : [],
        //   'following' : [],
        // });

        res = 'succes';
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
  Future<String> loginUser({
    required String email,
    required String password
  })async{
    String res = 'Some error occurred';

    try{
      if(email.isNotEmpty || password.isNotEmpty){
       await _auth.signInWithEmailAndPassword(email: email, password: password);
       res = 'success';
      }else{
        res= 'Please Enter all the field';
      }
    }catch(err){
      res = err.toString();
    }
    return res;
  }
}
