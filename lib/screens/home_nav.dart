import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import '../icons/custom_icons.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'quick_start_page.dart';
import 'workouts_page.dart';

class HomeNav extends StatefulWidget {
  HomeNav({Key? key, required this.currentIndex}) : super(key: key);
  int currentIndex;
  @override
  HomeNavState createState() => HomeNavState();
}

class HomeNavState extends State<HomeNav> {
  final pages = [
    const HomePage(),
    const QuickStartPage(),
    const WorkoutPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: widget.currentIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          color: Theme.of(context).colorScheme.primary,
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: BottomNavyBar(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          selectedIndex: widget.currentIndex,
          showElevation: false,
          containerHeight: 65,
          backgroundColor: Theme.of(context).colorScheme.primary,
          itemCornerRadius: 24,
          curve: Curves.ease,
          onItemSelected: (index) =>
              setState(() => widget.currentIndex = index),
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(CustomIcons.home)),
              title: const Text('Home'),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(CustomIcons.lightning),
              title: const Text('Quick Start'),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(CustomIcons.dumbbell),
              title: const Text(
                'Workouts',
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            // BottomNavyBarItem(
            //   icon: const Icon(CustomIcons.user),
            //   title: const Text('Profile'),
            //   activeColor: Colors.white,
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }
}
