import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final double minVolume = 0.0;
  final double minPitch = 0.5;
  final double minSpeechRate = 0.0;

  final double maxVolume = 1.0;
  final double maxPitch = 2.0;
  final double maxSpeechRate = 1.0;

  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 1.0;

  String language = 'en-US';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.black,
          padding: const EdgeInsets.only(left: 20),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 40,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Volume (${volume.toStringAsFixed(2)})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
              ),
              Slider(
                value: volume,
                min: minVolume,
                max: maxVolume,
                onChanged: (value) {
                  setState(() => volume = value);
                },
              ),

              const SizedBox(height: 10),

              Text(
                'Pitch (${pitch.toStringAsFixed(2)})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
              ),
              Slider(
                value: pitch,
                min: minPitch,
                max: maxPitch,
                onChanged: (value) {
                  setState(() => pitch = value);
                },
              ),

              const SizedBox(height: 10),

              Text(
                'Speech Rate (${speechRate.toStringAsFixed(2)})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
              ),
              Slider(
                value: speechRate,
                min: minSpeechRate,
                max: maxSpeechRate,
                onChanged: (value) {
                  setState(() => speechRate = value);
                },
              ),

              const SizedBox(height: 20),
              
              const Text(
                'Language',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
              ),
              DropdownButton<String>(
                items: const [
                  DropdownMenuItem(child: Text(""))
                ],
                onChanged: (value) => language = value!,
              ),
            ],
          ),
        ),
    );
  }

  void languageChange() {
    //
  }
}