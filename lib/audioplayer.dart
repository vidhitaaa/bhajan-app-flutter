import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _setupAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Player"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _progessBar(),
              Row(
                children: [
                  _playbackControlButton(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setupAudioPlayer() async {
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stacktrace) {
      print("A stream error occurred: $e");
    });

    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/darbar-v2.appspot.com/o/1.aac?alt=media&token=37d17805-fdc0-4568-b1bf-aa2bc72d0629")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Widget _progessBar() {
    return StreamBuilder<Duration?>(
      stream: _player.positionStream,
      builder: (context, snapshot) {
        return ProgressBar(
          progress: snapshot.data ?? Duration.zero,
          buffered: _player.bufferedPosition,
          total: _player.duration ?? Duration.zero,
          onSeek: (duration) {
            _player.seek(duration);
          },
        );
      },
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
