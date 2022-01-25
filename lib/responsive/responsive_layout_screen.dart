import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/dimension.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout(
      {Key? key,
      required this.mobileScreenLayout,
      required this.webScreenLayout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          //webScreen
          return webScreenLayout;
        }
        //mobile Screen
        return mobileScreenLayout;
        
      },
    );
  }
}
