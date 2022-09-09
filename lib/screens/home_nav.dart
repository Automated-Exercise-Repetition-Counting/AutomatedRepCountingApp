import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import '../icons/custom_icons.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'quick_start_page.dart';
import 'workouts_page.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({Key? key}) : super(key: key);

  @override
  HomeNavState createState() => HomeNavState();
}

class HomeNavState extends State<HomeNav> {
  int _currentIndex = 0;
  final pages = [HomePage(), QuickStartPage(), WorkoutPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    CustomIcons.dumbbell,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  )),
              Text('RepetitionCounter',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20))
            ]),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      bottomNavigationBar: Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(30.0),
          color: Theme.of(context).colorScheme.primary,
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: false,
          containerHeight: 65,
          backgroundColor: Theme.of(context).colorScheme.primary,
          itemCornerRadius: 24,
          curve: Curves.ease,
          onItemSelected: (index) => setState(() => _currentIndex = index),
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(CustomIcons.home),
              title: Text('Home'),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(CustomIcons.lightning),
              title: Text('Quick Start'),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(CustomIcons.dumbbell),
              title: Text(
                'Workouts',
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(CustomIcons.user),
              title: Text('Profile'),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
