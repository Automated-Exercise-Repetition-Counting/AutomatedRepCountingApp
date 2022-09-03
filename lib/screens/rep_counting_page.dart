import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../vision_detector_views/pose_detector_view.dart';
import 'results.dart';

class CameraPage extends StatefulWidget {
  CameraPage({Key? key, required this.reps, required this.exerciseType})
      : super(key: key);
  final int reps;
  final String exerciseType;

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  late CameraController _cameraController;
  late Future<void> _initController;
  var isCameraReady = false;

  @override
  void initState() {
    super.initState();
    initCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _cameraController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _cameraController != null
          ? _initController = _cameraController.initialize()
          : null;
    }
    if (!mounted) return;
    setState(() {
      isCameraReady = true;
    });
  }

  Widget cameraWidget(context) {
    var camera = _cameraController.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Transform.scale(
        scale: scale, child: Center(child: CameraPreview(_cameraController)));
  }

  @override
  Widget build(BuildContext context) {
    var reps = widget.reps;
    int countedReps = 0;
    return Scaffold(
        body: FutureBuilder(
            future: _initController,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    // cameraWidget(context),
                    PoseDetectorView(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white.withOpacity(0.6),
                                child: IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  iconSize: 30,
                                  color: Colors.black,
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ),
                              const Spacer(),
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white.withOpacity(0.6),
                                child: IconButton(
                                  icon: const Icon(Icons.check),
                                  iconSize: 25,
                                  color: Colors.black,
                                  onPressed: () {
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ResultsPage(
                                                desiredReps: reps,
                                                countedReps: countedReps,
                                                exerciseType:
                                                    widget.exerciseType)),
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Container(
                              width: 380,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(countedReps.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2),
                                      Text('out of $reps',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  Future<void> initCamera() async {
    final camera = await availableCameras();
    final firstCamera = camera.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.high);
    _initController = _cameraController.initialize();
    if (!mounted) return;
    setState(() {
      isCameraReady = true;
    });
  }
}
