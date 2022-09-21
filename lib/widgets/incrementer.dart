import 'package:flutter/material.dart';
import 'package:puioio/models/index.dart';

class Incrementer extends StatefulWidget {
  Incrementer({Key? key, required this.reps}) : super(key: key);
  Index reps;

  @override
  IncrementerState createState() => IncrementerState();
}

class IncrementerState extends State<Incrementer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.remove),
            iconSize: 30,
            onPressed: () {
              setState(() {
                if (widget.reps.index > 1) {
                  widget.reps.set(widget.reps.index - 1);
                }
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('${widget.reps.index}',
                style: const TextStyle(color: Colors.black, fontSize: 44)),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 30,
            onPressed: () {
              setState(() {
                widget.reps.set(widget.reps.index + 1);
              });
            },
          ),
        ],
      ),
    );
  }
}
