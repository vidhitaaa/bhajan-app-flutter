import 'package:bhajan_app_flutter/MyHomepage.dart';
import 'search_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../env.sample.dart';
import '../models/bhajan.dart';
import 'package:http/http.dart' as http;
import 'appConstants.dart';
//import 'package:getwidget/getwidget.dart';

class Contentspage extends StatefulWidget {
  const Contentspage({super.key});

  @override
  _ContentsPageState createState() => _ContentsPageState();
}

class _ContentsPageState extends State<Contentspage> {
  List<Bhajan> bhajans = [];
  var isLoaded = false;
  var isLoading = false;
  int currentPage = 1;
  bool hasMore = true;
  Set<int> loadedBhajanIds = Set<int>();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Fetch Data from API
    getData(currentPage);
    // Add scroll listener for infinite scrolling
    _scrollController = ScrollController();
    _addScrollListener(_scrollController);
  }

  _addScrollListener(ScrollController scrollController) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Reached the bottom, load more data
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (!isLoading && hasMore) {
      setState(() {
        isLoading = true;
      });

      try {
        List<Bhajan>? data = await getData(currentPage + 1);
        if (data != null && data.isNotEmpty) {
          setState(() {
            currentPage = currentPage + 1;
            isLoading = false;
            hasMore = data.length > 0; // Continue if there's more data
          });
        } else {
          setState(() {
            isLoading = false;
            hasMore = false; // Stop if no more data
          });
        }
      } catch (error) {
        print('Error loading more data: $error');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<List<Bhajan>?> getData(int page) async {
    try {
      var client = http.Client();
      var remoteService = RemoteService(client);
      // Fetch data from the API
      List<Bhajan>? newBhajans = await remoteService.getBhajans(page);

      if (newBhajans != null) {
        List<Bhajan> uniqueBhajans = [];
        for (var bhajan in newBhajans) {
          if (!loadedBhajanIds.contains(bhajan.sequenceNo)) {
            uniqueBhajans.add(bhajan);
            loadedBhajanIds.add(bhajan.sequenceNo);
          }
        }

        if (uniqueBhajans.isNotEmpty) {
          setState(() {
            bhajans.addAll(uniqueBhajans);
            isLoaded = true;
          });
          return uniqueBhajans;
        } else {
          // No unique items to add
          isLoaded = false;
          return null;
        }
      } else {
        isLoaded = false;
        return null;
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  Future<void> _search(int enteredNumber) async {
    try {
      String slug =
          await RemoteService(http.Client()).findBhajan(enteredNumber);
      // Navigate to MyHomepage with the found slug
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomepage(slug: slug),
        ),
      );
    } catch (error) {
      print('Error finding Bhajan: $error');
      // Handle error, e.g., show an error message
    }
  }

  @override
  void dispose() {
    // Dispose of the ScrollController when the widget is disposed
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bhagat Pahlaj Bhajanmala',
          style: TextStyle(
            fontFamily: 'Ribeye',
          ),
        ),
        backgroundColor: const Color(0xFF390000),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('images/bg.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.05), BlendMode.dstATop),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Bhajans',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF390000),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: bhajans.length + 1,
                  itemBuilder: (context, index) {
                    if (index < bhajans.length) {
                      return Card(
                        color: Color(0x80FFEDCB),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MyHomepage(slug: bhajans[index].slug),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    root +
                                        bhajans[index]
                                            .coverPhoto, // Use the URL fetched from the API
                                    width: 120,
                                    height: 120,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bhajans![index]
                                            .sequenceNo
                                            .toString(), // Convert integer to string
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF390000),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        bhajans![index].titleHindi,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF390000),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        bhajans![index].titleEnglish,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF390000),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16);
                  },
                ),
              ),
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
        onTap: (int index) {
          if (index == 0) {
            // Open search modal
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return SearchModal(
                  onOkPressed: (int enteredNumber) {
                    print('Entered number: $enteredNumber');
                    // Call search function to find the Bhajan
                    _search(enteredNumber);
                  },
                );
              },
            );
          } else {
            // Navigate to home page or perform any other action
          }
        },
      ),
    );
  }
}
