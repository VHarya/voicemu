import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:voicemu/language_name.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts _tts = FlutterTts();
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
  
  final TextEditingController _textController = TextEditingController();
  final List<String> _initListItem = [
    "Hello",
    "My name is John Doe",
    "What's your name?",
    "I'm okay",
    "Excuse me",
    "What is that?",
    "Thanks",
    "Good Bye",
    "Okay",

    "Nice to meet you",
    "Alright",
    "I'll get it",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur justo mi, aliquam id mi convallis, sodales tempor ipsum. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque vel orci quis risus rutrum tincidunt. Duis at ornare eros, eu vulputate enim. In tempus augue at nisi placerat aliquet quis maximus nibh. Mauris tincidunt accumsan odio, non venenatis lacus maximus eu. Proin orci augue, blandit sit amet tellus in, feugiat facilisis nisi. Aenean rhoncus tortor erat, ac malesuada odio suscipit ac. Morbi a vehicula ipsum. Fusce vehicula mauris in mi pharetra, vitae commodo leo rutrum."
  ];

  final int itemPerPage = 9;
  
  List<List<String>> _divListItem = [];
  List<String> listItem = [];

  int pageCount = 0;
  int currPage = 0;

  bool isSpeaking = false;
  bool loading = true;


  void _speak(String? text) async {
    setState(() => isSpeaking = true);

    _tts.errorHandler = (message) => print("error message $message");
    _tts.completionHandler = () => setState(() => isSpeaking = false);

    if (text != null) {
      await _tts.speak(text);
      return;
    }

    await _tts.speak(_textController.text);
  }

  void _stop() async {
    await _tts.stop();
    setState(() => isSpeaking = false);
  }

  void _prevQuickAccess() {
    if (currPage > 1) {
      currPage--;
      listItem = _divListItem[currPage-1];
      
      setState(() {});
    }
  }

  void _nextQuickAccess() {
    if (currPage < pageCount) {
      currPage++;
      listItem = _divListItem[currPage-1];
      
      setState(() {});
    }
  }

  void dividePaging() {
    _divListItem.clear();

    for (var i = 0; i < _initListItem.length; i += itemPerPage) {
      var start = i;
      var end = i + itemPerPage;

      if (end < _initListItem.length) {
        _divListItem.add( _initListItem.sublist(start, end) );
      } else {
        _divListItem.add( _initListItem.sublist(start, _initListItem.length) );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() => loading = true);

    pageCount = (_initListItem.length / 9).ceil();
    currPage = 1;
    
    dividePaging();
    listItem = _divListItem[currPage-1];

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return loading ?
      Material(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              'Loading',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Please wait a moment...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300
              ),
            ),
          ],
        )
      ) :
      Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'VoiceMU',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              onPressed: settingsModal,
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                buildTextSpeech(),
                const SizedBox(height: 20),
                buildQuickAccess(),
              ],
            ),
          ),
        ),
      );
  }

  Widget buildTextSpeech() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: TextField(
            controller: _textController,
            maxLines: 10,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
              hintText: "Enter text here",
              hintStyle: TextStyle(
                color: Color(0xFFBABABA),
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              )
            ),
          ),
        ),
        const SizedBox(height: 15),
        isSpeaking ?
          TextButton(
            onPressed: () => _stop(),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFEA8888),
              padding: const EdgeInsets.all(15)
            ),
            child: const Text(
              'Stop',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ) :
          TextButton(
            onPressed: () => _speak(null),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFA4DF96),
              padding: const EdgeInsets.all(15)
            ),
            child: const Text(
              'Speak',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget buildQuickAccess() {
    return Column(
      children: [
        const Text(
          'Quick Access',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 340,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 1.15 / 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10
            ),
            shrinkWrap: true, 
            itemCount: listItem.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => _speak(listItem[index]),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      listItem[index],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => _prevQuickAccess(),
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.black,
              ),
            ),
            Text(
              "$currPage of $pageCount",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            IconButton(
              onPressed: () => _nextQuickAccess(),
              icon: const Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void settingsModal() async {
    var ttsLanguages = await _tts.getLanguages;
    var languageLocal = LanguageLocal();
    print(ttsLanguages);

    List<DropdownMenuItem<String>> items = [];
    for (var element in ttsLanguages) {
      String convertedElement = element.toString();

      if (convertedElement.contains("-")) {
        var langTest = convertedElement.toString().split("-");
        var languageName = languageLocal.getDisplayLanguage(langTest[0]);
        
        items.add(
          DropdownMenuItem(
            value: "${langTest[0]}-${langTest[1]}",
            child: Text("${languageName['nativeName']} (${langTest[1]})"),
          )
        );
      }
      else {
        var languageName = languageLocal.getDisplayLanguage(convertedElement);

        items.add(
          DropdownMenuItem(
            value: convertedElement,
            child: Text("${languageName['nativeName']} ($convertedElement)"),
          )
        );
      }
    }

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                color: Colors.white
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 5,
                            width: 80,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFD6D6D6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
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
                          'Speed (${speechRate.toStringAsFixed(2)})',
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
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Language',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            DropdownButton<String>(
                              items: items,
                              value: language,
                              onChanged: (value) => setState(() => language = value!),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
          ],
        );

      },
    ).whenComplete(() async {
      await _tts.setVolume(volume);
      await _tts.setPitch(pitch);
      await _tts.setSpeechRate(speechRate);
      await _tts.setLanguage(language);
    });
  }
}