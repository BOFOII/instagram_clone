import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveScreenLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveScreenLayout(
      {super.key,
      required this.webScreenLayout,
      required this.mobileScreenLayout});

  @override
  State<ResponsiveScreenLayout> createState() => _ResponsiveScreenLayoutState();
}

class _ResponsiveScreenLayoutState extends State<ResponsiveScreenLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    await Provider.of<UserProvider>(context, listen: false).refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (p0, p1) {
      if (p1.maxWidth > webScreenSize) {
        return widget.webScreenLayout;
      }

      return widget.mobileScreenLayout;
    });
  }
}
