import 'package:flutter/material.dart';
import 'package:google_ml_kit_example/screens/rep_counting_page.dart';

import '../rep_counting/exercise_type.dart';

class SetUpPage extends StatefulWidget {
  const SetUpPage(
      {Key? key,
      required this.exerciseName,
      required this.reps,
      required this.exerciseType})
      : super(key: key);
  final String exerciseName;
  final int reps;
  final ExerciseType exerciseType;

  @override
  SetUpPageState createState() => SetUpPageState();
}

class SetUpPageState extends State<SetUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(81, 191, 192, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            icon: Icon(Icons.close),
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 20, 50, 100),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Text(
            'Get your phone into position',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                decoration: TextDecoration.none),
          ),
          Spacer(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(Icons.timer_10, color: Colors.white, size: 34),
              ),
              Flexible(
                child: Text(
                  'You will have 10s to get into position',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.none),
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(Icons.accessibility, color: Colors.white, size: 34),
              ),
              Flexible(
                child: Text('Position yourself 2m away from the phone',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.none)),
              ),
            ],
          ),
          Spacer(),
          Row(children: [
            Padding(
                padding: const EdgeInsets.only(right: 15),
                child:
                    Icon(Icons.exposure_plus_1, color: Colors.white, size: 34)),
            Flexible(
              child: Text(
                  'For every rep you perform, the display with update your count',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.none)),
            ),
          ]),
          Spacer(),
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(Icons.swap_vert, color: Colors.white, size: 34),
            ),
            Flexible(
              child: Text(
                  'You will also be able to see what ‘phase’ of the exercise movement you are in',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.none)),
            ),
          ]),
          Spacer(),
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(Icons.check_rounded, color: Colors.white, size: 34),
            ),
            Flexible(
              child: Text(
                  'If you finish before the desired number of reps are achieved, press the tick icon',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.none)),
            ),
          ]),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                primary: Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.fromLTRB(70, 10, 70, 10)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RepCountingPage(
                          exerciseName: widget.exerciseName,
                          reps: widget.reps,
                          exerciseType: widget.exerciseType,
                        )),
              );
            },
            child:
                const Text("I'm ready!", style: TextStyle(color: Colors.black)),
          ),
        ]),
      ),
    );
  }
}
