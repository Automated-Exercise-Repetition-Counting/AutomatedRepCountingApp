import 'package:flutter/material.dart';
import 'package:puioio/icons/custom_icons.dart';

class PuioioAppBar {
  static getAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  CustomIcons.dumbbell,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                )),
            Text('Pūioio',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 25))
          ]),
        ),
      ),
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
    );
  }
}
