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

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _fetchBhajanDetails();
    // _setupAudioPlayer(widget.index);
  }

  Future<Bhajandetails?> _fetchBhajanDetails() async {
    try {
      var client = http.Client();
      var service = RemoteServicedetails(client);
      return await service.getBhajansdetails(widget.slug);
    } catch (e) {
      print("Error fetching bhajan details: $e");
      return null;
    }
  }

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
          child: FutureBuilder<Bhajandetails?>(
            future: _fetchBhajanDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                Bhajandetails bhajanDetails = snapshot.data!;
                return ListView(
                  children: [
                    GFListTile(
                      avatar: Image.network(
                        "http://127.0.0.1:8000${bhajanDetails.coverPhoto}", // Use the URL fetched from the API
                        width: 120,
                        height: 120,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error);
                        },
                      ),
                      title: Text(
                        bhajanDetails.titleHindi,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF390000),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subTitle: Text(
                        bhajanDetails.titleEnglish,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF390000),
                        ),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size(MediaQuery.of(context).size.width, 500),
                      child: Align(
                        alignment: Alignment.center,
                        child: PageView(
                          children: [
                            Center(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: bhajanDetails.lyricsHindi
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
                                  children: bhajanDetails.lyricsEnglish
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
                );
              }
              return const SizedBox();
            },
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
