import 'package:bhajan_app_flutter/details_service.dart';
import 'package:bhajan_app_flutter/models/bhajan_details.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:http/http.dart' as http;
import 'page_manager.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class MyHomepage extends StatefulWidget {
  final String slug;
  MyHomepage({required this.slug});
  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  late final PageManager _pageManager;
  late Future<Bhajandetails?> _bhajanDetailsFuture;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _bhajanDetailsFuture = _fetchBhajanDetails();
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
  void dispose() {
    _pageManager.dispose();
    super.dispose();
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
            future: _bhajanDetailsFuture,
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
                _pageManager = PageManager(bhajanDetails.audioUrl);
                return ListView(
                  children: [
                    GFListTile(
                      avatar: Image.network(
                        "http://127.0.0.1:8000${bhajanDetails.coverPhoto}",
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
                    Container(
                      height: 300, // Adjust the height as needed
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
                                            fontSize: 25,
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
                                            fontSize: 25,
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
                    const SizedBox(
                        height:
                            20), // Add spacing between the PageView and ProgressBar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: ValueListenableBuilder<ProgressBarState>(
                        valueListenable: _pageManager.progressNotifier,
                        builder: (_, value, __) {
                          return ProgressBar(
                            onSeek: _pageManager.seek,
                            progress: value.current,
                            buffered: value.buffered,
                            total: value.total,
                          );
                        },
                      ),
                    ),
                    ValueListenableBuilder<ButtonState>(
                      valueListenable: _pageManager.buttonNotifier,
                      builder: (_, value, __) {
                        switch (value) {
                          case ButtonState.loading:
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              width: 32.0,
                              height: 32.0,
                              child: const CircularProgressIndicator(),
                            );
                          case ButtonState.paused:
                            return IconButton(
                              icon: const Icon(Icons.play_arrow),
                              iconSize: 32.0,
                              onPressed: _pageManager.play,
                            );
                          case ButtonState.playing:
                            return IconButton(
                              icon: const Icon(Icons.pause),
                              iconSize: 32.0,
                              onPressed: _pageManager.pause,
                            );
                        }
                      },
                    ),
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
}
