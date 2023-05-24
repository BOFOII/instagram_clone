import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  void initState() {
    super.initState();
    pageController = PageController();
  }

  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTap(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;

    return user == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            bottomNavigationBar: CupertinoTabBar(
              onTap: navigationTap,
              backgroundColor: mobileBackgroundColor,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: _page == 0 ? primaryColor : secondaryColor,
                  ),
                  label: '',
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search,
                      color: _page == 1 ? primaryColor : secondaryColor),
                  label: '',
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_circle,
                    color: _page == 2 ? primaryColor : secondaryColor,
                  ),
                  label: '',
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    color: _page == 3 ? primaryColor : secondaryColor,
                  ),
                  label: '',
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: _page == 4 ? primaryColor : secondaryColor,
                  ),
                  label: '',
                  backgroundColor: primaryColor,
                ),
              ],
            ),
            body: user == null
                ? const Center(
                    child: CircularProgressIndicator(
                    color: primaryColor,
                  ))
                : PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: onPageChange,
                    controller: pageController,
                    children: homeScreenItems,
                  ),
          );
  }
}
