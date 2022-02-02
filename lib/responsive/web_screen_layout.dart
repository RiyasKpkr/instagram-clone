import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WebeScreenLayout extends StatefulWidget {
  const WebeScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebeScreenLayout> createState() => _WebeScreenLayoutState();
}

class _WebeScreenLayoutState extends State<WebeScreenLayout> {



  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('this is web sreen layout'),
      ),
    );
  }
}
