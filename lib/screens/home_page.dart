import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_ml_kit_example/rep_counting/exercise_type.dart';

import 'rep_counting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final CarouselController _controller = CarouselController();
  List<ExerciseType> _exerciseTypes = ExerciseType.values;
  final List<Color> _exerciseColors = [
    const Color.fromRGBO(81, 191, 192, 1),
    const Color.fromRGBO(248, 85, 66, 1),
    const Color.fromRGBO(254, 196, 73, 1)
  ];
  var _reps = 1;
  int _chosenExerciseIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text(
              'Choose an',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Text(
            'Exercise',
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 40.0),
            child: SingleChildScrollView(
              child: CarouselSlider(
                options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        _chosenExerciseIndex = index;
                      });
                    },
                    enlargeCenterPage: true,
                    viewportFraction: 0.7,
                    height: 300),
                items: _exerciseTypes
                    .map((item) => Container(
                          padding: const EdgeInsets.all(5.0),
                          width: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/img/$item.png')),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(item.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none))),
                        ))
                    .toList(),
                carouselController: _controller,
              ),
            ),
          ),
          Text('Select a number of reps',
              style: Theme.of(context).textTheme.subtitle1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove),
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      if (_reps > 1) {
                        _reps -= 1;
                      }
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('$_reps',
                      style:
                          const TextStyle(color: Colors.black, fontSize: 64)),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      _reps += 1;
                    });
                  },
                )
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                primary: _exerciseColors[_chosenExerciseIndex],
                padding: const EdgeInsets.fromLTRB(80, 10, 80, 10)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CameraPage(
                          reps: _reps,
                          exerciseType: _exerciseTypes[_chosenExerciseIndex],
                        )),
              );
            },
            child: const Text('Begin'),
          ),
        ],
      ),
    ));
  }
}
