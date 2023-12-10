import 'dart:io';
import 'package:flutter/material.dart';
import 'package:learn_flutter/Utils/BackButtonHandler.dart';
import 'package:learn_flutter/VIdeoSection/CameraApp.dart';
import 'package:learn_flutter/VIdeoSection/VideoPreviewStory/video_database_helper.dart';
import 'package:learn_flutter/VIdeoSection/VideoPreviewStory/video_info2.dart';
import 'package:video_player/video_player.dart';
import 'package:learn_flutter/VIdeoSection/ComposePage.dart';
import 'package:learn_flutter/CustomItems/VideoAppBar.dart';
import 'package:learn_flutter/CustomItems/imagePopUpWithOK.dart';
import 'package:geolocator/geolocator.dart';


Map<String, List<VideoInfo>> videoData = {};

class VideoInfo {
  final String videoUrl;
  final double latitude;
  final double longitude;

  VideoInfo({
    required this.videoUrl,
    required this.latitude,
    required this.longitude,
  });
}

class VideoPreviewPage extends StatefulWidget {
  final List<String> videoPaths;
  final String userLocation;
  final double latitude;
  final double longitude;



  VideoPreviewPage({
    required this.videoPaths,
    required this.userLocation,
    required this.latitude,
    required this.longitude,

  });

  @override
  _VideoPreviewPageState createState() => _VideoPreviewPageState();
}



class _VideoPreviewPageState extends State<VideoPreviewPage> {




  double? firstVideoLatitude;
  double? firstVideoLongitude;
  double? userLatitude;
  double? userLongitude;
  late VideoDatabaseHelper _databaseHelper;


  @override
  void initState() {
    super.initState();

    _databaseHelper = VideoDatabaseHelper();

    // Add videos to videoData when the page loads

    print('init state here');

    for (int i = 0; i < widget.videoPaths.length; i++) {
      addVideo(widget.userLocation, widget.videoPaths[i], widget.latitude, widget.longitude);

      // Save the latitude and longitude of the first video
      if (i == 0) {
        firstVideoLatitude = widget.latitude;
        firstVideoLongitude = widget.longitude;
      }




    }


  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Continue Previous Story?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to continue the previous story or start a new one?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Navigate to VideoPreviewPage with data from the database
                List<VideoInfo2> videos = await _databaseHelper.getAllVideos();
                List<VideoInfo2> allVideos = await VideoDatabaseHelper().getAllVideos();

                // Extract the required data from the list of videos
                List<String> videoPaths = videos.map((video) => video.videoUrl).toList();
                String userLocation = ''; // Replace with your logic to get user location
                double latitude = allVideos[0].latitude;
                double longitude = allVideos[0].longitude;

                print('latitude : $latitude');
                print('longitude : $longitude');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPreviewPage(
                      videoPaths: videoPaths,
                      userLocation: userLocation,
                      latitude: latitude,
                      longitude: longitude,
                    ),
                  ),
                );

              },
              child: Text('Continue'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Start a new story
                Navigator.push(context, MaterialPageRoute(builder: (context) => CameraApp()));
              },
              child: Text('New Story'),
            ),
          ],
        );
      },
    );
  }



  bool isWithinRadius(double firstLatitude, double firstLongitude, double newLatitude, double newLongitude, double radius) {
    double distance = Geolocator.distanceBetween(firstLatitude, firstLongitude, newLatitude, newLongitude);
    return distance <= radius;
  }

  Future<void> fetchUserLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );



    print('fetch user location in video preview page');

    setState(() {
      userLatitude = position.latitude;
      userLongitude = position.longitude;
    });

    print('user latitude : $userLatitude');

    handleAddNewVideoButton();
  }


  void handleAddNewVideoButton() async{
    if (userLatitude != null && userLongitude != null) {
      double radiusInMeters = 200.0;
      double distance = Geolocator.distanceBetween(
        userLatitude!,
        userLongitude!,
        firstVideoLatitude!,
        firstVideoLongitude!,

      );
      print('distance');
      print(distance);


      if (distance <= radiusInMeters) {
        // User is within the radius; they can proceed to create a new video
        print('Location checked - User is within 500 meters.');
        bool hasVideos = await VideoDatabaseHelper().hasVideos();



        if(hasVideos){

          print('has Videos');
          Navigator.push(context, MaterialPageRoute(builder: (context) => CameraApp()));

        }
        else{
          Navigator.pop(context);
        }

        print('location checked');
        print(radiusInMeters);
        print("firstVideoLatitude");
        print(firstVideoLatitude);
        print(firstVideoLongitude);
        print('location right now');
        print(widget.latitude);
        print(widget.longitude);
        print('distance');
        print(distance);
      } else {
        // User is outside the radius; show a dialog
        showDialog(
          context: context,
          builder: (context) {
            return ImagePopUpWithOK(
                imagePath: 'assets/images/range.svg',
                textField: 'Your range is getting extended Please upload or save your last recordings before the next shoot, ',
                extraText:'*Your draft will be available under thesettings option.',
                what:'ok');
          },
        );
      }
    }
  }






  void addVideo(String location, String videoUrl, double latitude, double longitude) {
    final videoInfo = VideoInfo(
      videoUrl: videoUrl,
      latitude: latitude,
      longitude: longitude,
    );

    videoData[location] = [videoInfo];


  }

  Future<void> _handleRefresh() async {
    // Perform any asynchronous operation (e.g., refetching data) here
    await Future.delayed(Duration(seconds: 1));



    // Call setState to trigger a rebuild of the widget


    // You can print a message if needed
    print('Page refreshed');
  }


  Future<void> removeVideo(String videoPath) async {
    setState(() {
      // Find the location associated with the videoPath
      String location = widget.userLocation;

      if (videoData.containsKey(location)) {
        // Find the index of the video with the given path within the location
        int index = videoData[location]!.indexWhere((videoInfo) => videoInfo.videoUrl == videoPath);

        if (index != -1) {
          // Remove the video info from videoData
          videoData[location]!.removeAt(index);

          // If there are no videos left for that location, remove the location key
          if (videoData[location]!.isEmpty) {
            videoData.remove(location);
          }
        }
      }

      // Remove the video path from widget.videoPaths
      int pathIndex = widget.videoPaths.indexOf(videoPath);
      if (pathIndex != -1) {
        // Remove the video file from local storage asynchronously
        VideoDatabaseHelper().deleteVideoByPath(videoPath);
        // Remove the video path from the list
        widget.videoPaths.removeAt(pathIndex);
      }
    });

    if (widget.videoPaths.isEmpty) {
      Navigator.pop(context);

    } else {
      _handleRefresh();
    }
  }

  BackButtonHandler backButtonHandler4 = BackButtonHandler(
    imagePath: 'assets/images/exit.svg',
    textField: 'Save Your Story And Exit?',
    what: 'Home',
    button1: 'Add New',
    button2: 'Save',
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => backButtonHandler4.onWillPop(context, true),
    child: Scaffold(
      appBar: VideoAppBar(
        title:'Edit Story',
        exit : 'a',
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Container(
          color: Color(0xFF263238),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                  ),
                  itemCount: widget.videoPaths.length,
                  itemBuilder: (context, index) {
                    return VideoItem(
                      videoPath: widget.videoPaths[index],
                      videoNumber: index + 1,
                      onClosePressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Color(0xFF263238),
                              content: Container(
                                height: 269,
                                width: 300,
                                child: Column(
                                  children: [
                                    SizedBox(height: 30),
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Center(
                                        child: Image.asset('assets/images/remove.png'),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Text(
                                      'Are You Sure?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(),
                                        child: Column(
                                          children: [
                                            Text(
                                              'You are removing a film shoot',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [

                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Remove video logic here
                                        removeVideo(widget.videoPaths[index]);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Remove',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            );
                          },
                        );

                      },
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 50,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(
                                    value: 1,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.orange,
                                    ),
                                    strokeWidth: 10.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: IconButton(
                                    icon: Image.asset("assets/images/addNewButton.png"),
                                    onPressed: fetchUserLocation,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Add New Film',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          child: Container(
                            height: 100,
                            width: 80,
                            child: IconButton(
                              icon: Image.asset("assets/images/next_button.png"),
                              onPressed: () {
                                // Navigate to the next page
                                if (firstVideoLatitude != null && firstVideoLongitude != null) {
                                  // Navigate to the custom page with latitude and longitude
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ComposePage(
                                        latitude: firstVideoLatitude!,
                                        longitude: firstVideoLongitude!,
                                        videoPaths: widget.videoPaths,
                                        videoData: videoData,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Text(
                          'Next',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}

class VideoItem extends StatefulWidget {
  final String videoPath;
  final int videoNumber;
  final VoidCallback? onClosePressed;

  VideoItem({required this.videoPath, required this.videoNumber, this.onClosePressed});

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();



    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Continue Previous Story?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to continue the previous story or start a new one?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {

              },
              child: Text('Continue'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Start a new story
                Navigator.push(context, MaterialPageRoute(builder: (context) => CameraApp()));
              },
              child: Text('New Story'),
            ),
          ],
        );
      },
    );
  }



  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _controller.play();
    } else {
      _controller.pause();
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (_isFullScreen) {
      _controller.setVolume(1.0);
      _controller.play();
    } else {
      _controller.setVolume(0.0);
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _togglePlayPause();
      },
      onLongPress: () {
        _toggleFullScreen();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 4.0),
          ),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 2 / 3.15,
                child: VideoPlayer(_controller),
              ),
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 8.0,
                left: 8.0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Text(
                      widget.videoNumber.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 2.0,
                right: 2.0,
                child: IconButton(
                  onPressed: widget.onClosePressed,
                  icon: Icon(
                    Icons.highlight_remove_rounded,
                    size: 30.0,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}