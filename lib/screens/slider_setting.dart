import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class Slider_Setting extends StatelessWidget {
  const Slider_Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibrating Progress Bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity.copyWith(
          vertical: 4.0,
        ),
      ),
      home: VibratingProgressBar(),
    );
  }
}

class VibratingProgressBar extends StatefulWidget {
  @override
  _VibratingProgressBarState createState() => _VibratingProgressBarState();
}

class _VibratingProgressBarState extends State<VibratingProgressBar> {
  double currentValue = 0.0;

  void updateValue(double newValue) {
    if (newValue != currentValue) {
      vibrateDevice(newValue); // Vibrate the device with adjusted intensity

      setState(() {
        currentValue = newValue;
      });
    }
  }

  Future<void> vibrateDevice(double intensity) async {
    if (await Vibration.hasVibrator() != null) {
      int duration = (intensity * 1000).toInt();
      Vibration.vibrate(duration: duration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Listener(
          onPointerMove: (PointerMoveEvent event) {
            RenderBox box = context.findRenderObject() as RenderBox;
            Offset localPosition = box.globalToLocal(event.position);
            double newValue = localPosition.dx / box.size.width;
            updateValue(newValue);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: currentValue,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 30,
              ),
              SizedBox(height: 20), // Add spacing between the progress bar and the text
              Text(
                '진동 게이지: ${(currentValue * 100).toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}