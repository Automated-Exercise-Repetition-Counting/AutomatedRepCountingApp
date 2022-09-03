import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CircularProgressWithImage extends StatefulWidget {
  const CircularProgressWithImage(
      {Key? key,
      required this.countedReps,
      required this.desiredReps,
      required this.exerciseType});
  final int countedReps;
  final int desiredReps;
  final String exerciseType;

  @override
  CircularProgressWithImageState createState() =>
      CircularProgressWithImageState();
}

class CircularProgressWithImageState extends State<CircularProgressWithImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            axisLineStyle: AxisLineStyle(
              thickness: 0.15,
              cornerStyle: CornerStyle.bothCurve,
              color: Theme.of(context).colorScheme.secondary,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: widget.countedReps / widget.desiredReps * 100,
                color: Theme.of(context).colorScheme.primary,
                cornerStyle: CornerStyle.bothCurve,
                width: 0.15,
                sizeUnit: GaugeSizeUnit.factor,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                positionFactor: 0.1,
                angle: 90,
                widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Image(
                        image: AssetImage('assets/img/results.png'),
                        width: 150,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(widget.exerciseType,
                            style: Theme.of(context).textTheme.headline5),
                      ),
                    ]),
              ),
            ]),
      ]),
    );
  }
}
