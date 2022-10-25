import 'package:flutter/material.dart';

import 'package:voicemu/home.dart';
import 'package:voicemu/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Color(0xFFF2F2F2),
        primarySwatch: Colors.blue,
        sliderTheme: SliderThemeData(overlayShape: SliderComponentShape.noThumb, trackShape: CustomTrackShape()),
      ),
      initialRoute: "home",
      routes: {
        "home": (context) => const HomeScreen(),
        "settings": (context) => const SettingScreen(),
      },
    );
  }
}


class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
    }) {
      final double trackHeight = sliderTheme.trackHeight!;
      final double trackLeft = offset.dx;
      final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
      final double trackWidth = parentBox.size.width;
      return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
    }
}