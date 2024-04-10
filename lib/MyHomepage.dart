import 'package:bhajan_app_flutter/details_service.dart';
import 'package:bhajan_app_flutter/models/bhajan_details.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import '../env.sample.dart';
import '../models/bhajan.dart';
import 'package:http/http.dart' as http;

class MyHomepage extends StatefulWidget {
  final String slug;
  MyHomepage({required this.slug});
  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  final _player = AudioPlayer();
  Bhajandetails? bhajanDetails;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _fetchBhajanDetails();
    // _setupAudioPlayer(widget.index);
  }

  Future<void> _fetchBhajanDetails() async {
    try {
      var client = http.Client();
      var service = RemoteServicedetails(client);
      bhajanDetails = await service.getBhajansdetails(widget.slug);
      print(bhajanDetails);
      setState(() {}); // Call setState to update the UI with the fetched data
    } catch (e) {
      print("Error fetching bhajan details: $e");
    }
  }

  // var audiolinks = [
  //   'https://firebasestorage.googleapis.com/v0/b/darbar-v2.appspot.com/o/1.aac?alt=media&token=37d17805-fdc0-4568-b1bf-aa2bc72d0629',
  //   'https://firebasestorage.googleapis.com/v0/b/darbar-v2.appspot.com/o/2.aac?alt=media&token=d46e6d5a-4523-4faf-b494-e49c05bc6dd5',
  //   'https://firebasestorage.googleapis.com/v0/b/darbar-v2.appspot.com/o/3.aac?alt=media&token=0e39c16b-35b8-4055-ab74-3c9592150e0c',
  //   'https://firebasestorage.googleapis.com/v0/b/darbar-v2.appspot.com/o/4.aac?alt=media&token=0b9b370e-50ab-4a5c-bc47-9f27afa801da',
  //   'https://firebasestorage.googleapis.com/v0/b/darbar-v2.appspot.com/o/5.aac?alt=media&token=91b27a73-aca5-4cae-97ac-a3eb3b50dc9e',
  //   'https://firebasestorage.googleapis.com/v0/b/darbar-v2.appspot.com/o/6.aac?alt=media&token=3eb89e92-ae7f-4ac8-9655-2739f1e308f8',
  //   'https://firebasestorage.googleapis.com/v0/b/darbar-v2.appspot.com/o/7.aac?alt=media&token=4bebe514-2a1f-4047-9a7b-ffb0967ad802',
  //   'https://firebasestorage.googleapis.com/v0/b/darbar-v2.appspot.com/o/8.aac?alt=media&token=2d06130a-7be1-4b01-bbda-9751d7610507'
  // ];

  // Future<void> _setupAudioPlayer(int index) async {
  //   String link = audiolinks[index];
  //   _player.playbackEventStream.listen((event) {},
  //       onError: (Object e, StackTrace stacktrace) {
  //     print("A stream error occurred: $e");
  //   });

  //   try {
  //     await _player.setAudioSource(AudioSource.uri(Uri.parse(link)));
  //   } catch (e) {
  //     print("Error loading audio source: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sant Kavi Pahlajram Bhajanmala',
          style: TextStyle(
            fontFamily: 'Ribeye',
          ),
        ),
        backgroundColor: const Color(0xFF390000),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.05),
              BlendMode.dstATop,
            ),
          ),
          color: Colors.black.withOpacity(0.05),
        ),
        child: SafeArea(
          child: Column(
            children: [
              GFListTile(
                avatar: Image.asset(
                  bhajanDetails!.coverPhoto, // Adjust this line
                  width: 120,
                  height: 120,
                ),
                title: Text(
                  bhajanDetails!.titleHindi,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF390000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subTitle: Text(
                  bhajanDetails!.titleEnglish,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF390000),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: PageView(
                    children: [
                      Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: bhajanDetails!.lyricsHindi
                                .split('\n')
                                .map((line) => Text(
                                      line,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF390000),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: bhajanDetails!.lyricsEnglish
                                .split('\n')
                                .map((line) => Text(
                                      line,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF390000),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // _progessBar(),
              // _playbackControlButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Color(0xFFFFEDCB)),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xFFFFEDCB)),
            label: 'Home',
          ),
        ],
        backgroundColor: const Color(0xFF390000),
        selectedItemColor: const Color(0xFFFFEDCB),
      ),
    );
  }

  Widget _progessBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Adjust the padding as needed
      child: StreamBuilder<Duration?>(
        stream: _player.positionStream,
        builder: (context, snapshot) {
          return ProgressBar(
            progress: snapshot.data ?? Duration.zero,
            buffered: _player.bufferedPosition,
            total: _player.duration ?? Duration.zero,
            onSeek: (duration) {
              _player.seek(duration);
            },
            timeLabelTextStyle: TextStyle(
              color: const Color(0xFF390000),
            ),
            thumbColor: const Color(0xFF390000),
          );
        },
      ),
    );
  }

  Widget _playbackControlButton() {
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final processingState = snapshot.data?.processingState;
        final playing = snapshot.data?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 64,
            height: 64,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: 64,
            onPressed: _player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 64,
            onPressed: _player.pause,
          );
        } else {
          return IconButton(
              icon: const Icon(Icons.replay),
              iconSize: 64,
              onPressed: () => _player.seek(Duration.zero));
        }
      },
    );
  }
}
