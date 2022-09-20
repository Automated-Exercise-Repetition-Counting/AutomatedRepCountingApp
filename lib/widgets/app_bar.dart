import 'package:flutter/material.dart';
import 'package:puioio/icons/custom_icons.dart';
import 'package:puioio/screens/help_page.dart';

class PuioioAppBar {
  static getAppBar(
      BuildContext context, Color backgroundColor, bool showHelpAction) {
    return AppBar(
      toolbarHeight: 80,
      flexibleSpace: SafeArea(
        child: Stack(children: [
          Padding(
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
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 25)),
            ]),
          ),
          Visibility(
              visible: showHelpAction,
              child: Positioned(
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
              ))
        ]),
      ),
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0,
    );
  }
}
