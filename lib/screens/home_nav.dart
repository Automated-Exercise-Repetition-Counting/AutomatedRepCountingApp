import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import '../icons/custom_icons.dart';
import 'help_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'quick_start_page.dart';
import 'workouts_page.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({Key? key, this.currentIndex = 0}) : super(key: key);
  final int currentIndex;
  @override
  HomeNavState createState() => HomeNavState();
}

class HomeNavState extends State<HomeNav> {
  late int _currentIndex;
  final pages = [
    const HomePage(),
    const QuickStartPage(),
    const WorkoutPage(),
    const ProfilePage()
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        CustomIcons.dumbbell,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      )),
                  Text('Pūioio',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 25)),
                ]),
              ),
              Positioned(
                top: 29,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.help),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpPages(),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          color: Theme.of(context).colorScheme.primary,
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: BottomNavyBar(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          selectedIndex: _currentIndex,
          showElevation: false,
          containerHeight: 65,
          backgroundColor: Theme.of(context).colorScheme.primary,
          itemCornerRadius: 24,
          curve: Curves.ease,
          onItemSelected: (index) => setState(() => _currentIndex = index),
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: const Icon(CustomIcons.home),
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
            // BottomNavyBarItem(
            //   icon: const Icon(CustomIcons.dumbbell),
            //   title: const Text(
            //     'Workouts',
            //   ),
            //   activeColor: Colors.white,
            //   textAlign: TextAlign.center,
            // ),
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
