import 'dart:io';
import 'package:flutter/material.dart';
import 'package:learn_flutter/CustomItems/CustomFooter.dart';
import 'package:learn_flutter/CustomItems/loading_dialog.dart';
import 'package:learn_flutter/CustomItems/pulseUpload.dart';
import 'package:learn_flutter/HomePage.dart';

import 'package:video_player/video_player.dart';
import 'package:learn_flutter/CustomItems/VideoAppBar.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';
import 'package:learn_flutter/VIdeoSection/Draft_Local_Database/database_helper.dart';
import 'package:learn_flutter/VIdeoSection/Draft_Local_Database/draft.dart';
import 'package:learn_flutter/VIdeoSection/VideoPreviewStory/VideoPreviewPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:learn_flutter/CustomItems/imagePopUpWithOK.dart';
import 'dart:convert';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:learn_flutter/VIdeoSection/VideoPreviewStory/video_database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';


class UploadPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF263238),
      content: Container(
        height : 300,
        width : 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30),
            PulseEffect(),
            SizedBox(height: 30),
            // CircularProgressIndicator(
            //   color : Colors.orange,
            // ),
            SizedBox(height: 0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('While CulturTap Upload',style:TextStyle(fontWeight: FontWeight.bold, color: Colors.white,)),
                Text('Your Amazing Story...',style:TextStyle(fontWeight: FontWeight.bold, color: Colors.white,)),

              ],
            ),
            SizedBox(height: 30),
            Positioned(
              top : 30,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the homepage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),  // Replace with your homepage
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,  // Set the button color
                  onPrimary: Colors.white,  // Set the text color
                  textStyle: TextStyle(
                    fontSize: 18.0,  // Set the font size
                    fontWeight: FontWeight.bold,  // Set the font weight
                  ),
                ),
                child: Text('Explore Homepage'),
              ),
            )


          ],
        ),
      ),
    );
  }
}



class ComposePage extends StatefulWidget {
  VideoDatabaseHelper myDatabaseHelper = VideoDatabaseHelper();

  final List<String> videoPaths;
  final double latitude;
  final double longitude;
  final Map<String, List<VideoInfo>> videoData;

  ComposePage({
    required this.latitude,
    required this.longitude,
    required this.videoPaths,
    required this.videoData,
  });

  @override
  _ComposePageState createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {

  late VideoPlayerController _thumbnailController;
  late int randomIndex;

  String selectedLabel = 'Regular Story';
  String selectedCategory = 'Category 1';
  String selectedGenre = 'Genre 1'; // Default selected genre
  String experienceDescription = '';
  List<String> selectedLoveAboutHere = []; // Initialize as an empty list
  bool showOtherLoveAboutHereInput = false;
  TextEditingController loveAboutHereInputController = TextEditingController();
  String dontLikeAboutHere = ''; // New input for "What You Don't Like About This Place"
  String selectedaCategory = "Select1";
  String reviewText = ''; // New input for "Review This Place"
  int starRating = 0; // New input for star rating
  String selectedVisibility = 'Public';
  String liveLocation = "";
  String storyTitle = '';
  String productDescription = '';
  bool isSaveDraftClicked = false;
  bool isPublishClicked = false;
  String selectedOption = '';
  String productPrice = '';
  String transportationPricing = "";
  List<String> finalVideoPaths = [];

  List<String> currencyCode = [
    '₪', // Israeli New Shekel
    '¥', // Japanese Yen
    '€', // Euro
    '£', // British Pound Sterling
    '₹', // Indian Rupee
    '₣', // Swiss Franc
    '₱', // Philippine Peso
    '₩', // South Korean Won
    '₺', // Turkish Lira
    '฿', // Thai Baht

  ];

  String _selectedCurrencyCode = '₹'; // Default country code

  final List<String> loveAboutHereOptions = [
    'Beautiful',
    'Calm',
    'Party Place',
    'Pubs',
    'Restaurant',
    'Others',
  ];


  bool isFoodFamous = false;
  bool isFashionFamous = false;
  String foodType = '';
  String fashionType = '';

  bool _isVisible = true;


  Future<void> uploadCompressedVideos(List<File> videoPaths, BuildContext context) async {
    try {


      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return UploadPopup();
        },
      );


      List<String> compressedPaths = [];

      // Compress videos
      for (int i = 0; i < videoPaths.length; i++) {
        String compressedVideoPath = await compressVideo(videoPaths[i]);
        compressedPaths.add(compressedVideoPath);
        print('videopaths after compression $compressedPaths');
      }

      // Upload compressed videos
      final String serverUrl = 'http://173.212.193.109:8080/main/api/uploadVideos';
      final request = http.MultipartRequest('POST', Uri.parse(serverUrl));

      print('compressedPaths.length ${compressedPaths.length}');
      for (int i = 0; i < compressedPaths.length; i++) {
        // Extract filename and extension from the path
        String filename = 'culturTap.com_${path.basename(compressedPaths[i])}';
        String extension = path.extension(compressedPaths[i]);
        finalVideoPaths.add(filename);
        print('filename is : $filename');
        print('extension is : $extension');

        // Append filename and extension to the request
        request.files.add(
          await http.MultipartFile.fromPath('videos', compressedPaths[i],
              filename: filename, contentType: MediaType('video', extension)),
        );
      }

      final response = await request.send();

      // Close loading popup


      if (response.statusCode == 201) {
        // Successfully uploaded all compressed videos.
        // You can now save their URLs to MongoDB.
        // Add the logic to save video URLs to your MongoDB database here.
        print('Compressed videos successfully uploaded to the server');
        showDialog(
          context: context,
          builder: (context) {
            return ImagePopUpWithOK(
              imagePath: "assets/images/storyUploaded.svg",
              textField: "Your Story is Successfully Uploaded",
              what:"home",
              isDarkMode:"dark",



            );
          },
        );

      } else {
        print('Failed to upload compressed videos. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> compressVideo(File videoFile) async {
    String outputDirectory = '/root/videos';
    String outputFileName = 'video.mp4';

    String outputPath = '$outputDirectory/$outputFileName';

    FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();

    // Run FFmpeg command to compress the video
    int rc = await flutterFFmpeg.execute(
        '-i ${videoFile.path} -b:v 1500k -max_muxing_queue_size 1024 $outputPath');

    if (rc == 0) {
      // Compression successful
      return outputPath;
    } else {
      print('compression failed');
      // Compression failed
      return videoFile.path;
    }
  }




  List<File> convertPathsToFiles(List<String> videoPaths) {
    List<File> videoFiles = [];
    for (String path in videoPaths) {
      videoFiles.add(File(path));
    }
    return videoFiles;
  }


  Future<void> sendDataToBackend() async {



    List<File> videoFiles = convertPathsToFiles(widget.videoPaths);
    await uploadCompressedVideos(videoFiles,context);


    print('final video paths $finalVideoPaths');
    print('publish button clicked');
    try{
      VideoDatabaseHelper myDatabaseHelper = VideoDatabaseHelper();

      final data = {
        "singleStoryData": {
          "videoPath": finalVideoPaths,
          "latitude": widget.latitude,
          "longitude": widget.longitude,
          "location": liveLocation,
          "expDescription": experienceDescription,
          "placeLoveDesc": selectedLoveAboutHere.join(','),
          "dontLikeDesc": dontLikeAboutHere,
          "review": reviewText,
          "starRating": starRating,
          "selectedVisibility": selectedVisibility,
          "storyTitle": storyTitle,
          "productDescription": productDescription,
          "liveLocation" : liveLocation,
          "selectedOption": selectedOption,
          "productPrice": productPrice,
          "transportationPricing": transportationPricing,
          "label": selectedLabel,
          "category": selectedCategory,
          "genre": selectedGenre,
        },
        "label": selectedLabel,
        "category": selectedCategory,
        "genre": selectedGenre
      };


      print('printing data $data');

      final String serverUrl = 'http://173.212.193.109:8080/main/api/publish';

      final http.Response response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(data),
      );

      print('Response: ${response.statusCode} ${response.reasonPhrase}');

      if (response.statusCode == 201) {
        print('Data sent successfully yes yes');
        print('Response Data: ${response.body}');


        await myDatabaseHelper.deleteAllVideos();

      } else {
        print('Failed to send data. Error: ${response.reasonPhrase}');
      }
    }catch(error){
      print("Error: $error");
    }

  }




  late DatabaseHelper _databaseHelper;
  Future<void> saveDraft() async {
    final status = await Permission.storage.request();
    if(status.isGranted){
      final database = await DatabaseHelper.instance.database;
      final draft = Draft(
        latitude: widget.latitude,
        longitude: widget.longitude,
        liveLocation : liveLocation,
        videoPaths: widget.videoPaths.join(','),
        selectedLabel: selectedLabel,
        selectedCategory: selectedCategory,
        selectedGenre: selectedGenre,
        experienceDescription: experienceDescription,
        selectedLoveAboutHere: selectedLoveAboutHere.join(','),
        dontLikeAboutHere: dontLikeAboutHere,
        selectedaCategory: selectedaCategory,
        reviewText: reviewText,
        starRating: starRating,
        selectedVisibility: selectedVisibility,
        storyTitle: storyTitle,
        productDescription: productDescription,
        selectedOption: selectedOption,
        transportationPricing: transportationPricing,
        productPrice: productPrice,

      );

      final id = await database.insert('drafts', draft.toMap());
      print('Saved draft with ID: $id');

      // Save video files to local storage
      for (final videoPath in widget.videoPaths) {
        await _saveVideoToLocalStorage(videoPath);
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ImagePopUpWithOK(
            imagePath: "assets/images/savedraft.svg",
            textField: "Your Draft is saved , you can check your drafts on settings." ,
            what:'camera',


          );
        },
      );
    }
  }



  Future<void> _saveVideoToLocalStorage(String videoPath) async {
    VideoDatabaseHelper myDatabaseHelper = VideoDatabaseHelper();

    final localPath = (await getApplicationDocumentsDirectory()).path;
    final fileName = videoPath.split('/').last; // Extract the filename from the videoPath
    final localFilePath = '$localPath/$fileName';

    File videoFile = File(videoPath);
    await videoFile.copy(localFilePath);


    print('Video file copied to local storage: $localFilePath');
    await myDatabaseHelper.deleteAllVideos();
  }




//to get and print location name
  Future<void> getAndPrintLocationName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark first = placemarks.first;
        String locationName = "${first.name}, ${first.locality}, ${first.administrativeArea}, ${first.country}";
        setState(() {
          liveLocation = locationName;
        });
      } else {
        // Return latitude and longitude if location not found
        setState(() {
          liveLocation = '$latitude, $longitude';
        });
      }
    } catch (e) {
      print("Error: $e");
      // Return latitude and longitude in case of an error fetching location
      setState(() {
        liveLocation = '$latitude, $longitude';
      });
    }
  }



  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
    print("Video Data in initState: ${widget.videoData}");

    if (videoData.isNotEmpty) {
      final location = videoData.keys.first; // Get the first location in the map
      final firstVideoInfo = videoData[location]![0];
// Get the first VideoInfo in the list

      print("Video Data in initState: ${firstVideoInfo.videoUrl}");

    }



    getAndPrintLocationName(widget.latitude, widget.longitude);
    randomIndex = Random().nextInt(widget.videoPaths.length);
    _thumbnailController = VideoPlayerController.file(File(widget.videoPaths[randomIndex]))
      ..initialize().then((_) {
        setState(() {});
      });


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VideoAppBar(
        title : 'Compose Story',
        exit : 'b',
      ),
      body: Container(
        color: Color(0xFF263238),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [


              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    constraints: BoxConstraints(
                      maxWidth: 300,
                      maxHeight: 300,
                    ),
                    child: AspectRatio(
                      aspectRatio: _thumbnailController.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(_thumbnailController),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 4.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.only(left: 26.0),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Location',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),



                      ],

                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Row(
                      children: [

                        SizedBox(width: 18),
                        Text(
                          liveLocation.isNotEmpty ? liveLocation : 'Fetching Location...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  Padding(
                    padding: EdgeInsets.only(left: 26.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Differentiate this experience as ',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'poppins'),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Color(0xFF263238), // Set the background color of the dropdown here
                          ),

                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Color(0xFF263238), // Set the background color of the dropdown here
                            ),
                            child: DropdownButton<String>(
                              value: selectedLabel,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedLabel = newValue!;
                                });
                              },
                              items: <String>['Regular Story', 'Business Product']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              icon: Icon(Icons.keyboard_arrow_down, color: Colors.orange),
                              underline: Container(
                                height: 2,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding : EdgeInsets.all(26.0),
                    child : Container(
                      height : 0.5,
                      decoration: BoxDecoration(
                        color : Colors.grey,
                      ),
                    ),

                  ),

                ],),

              //for regular story

              Visibility(
                visible: selectedLabel == 'Regular Story',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    // category for regular stories
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),


                          Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Color(0xFF263238), // Set the background color of the dropdown here
                            ),
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCategory = newValue!;
                                });
                              },
                              items: <String>['Category 1','Solo trip', 'Trip With Friends', 'Trip With Family', 'Office Trip', 'School Trip', 'Picnic']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              icon: Icon(Icons.keyboard_arrow_down, color: Colors.orange),
                              underline: Container(
                                height: 2,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    SizedBox(height: 35),

                    //genre for regular story
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Genre',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Color(0xFF263238), // Set the background color of the dropdown here
                            ),
                            child: DropdownButton<String>(
                              value: selectedGenre,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedGenre = newValue!;
                                });
                              },
                              items: <String>['Genre 1', 'Lifestyle', 'Street Foods', 'Restaurants' , 'Party - Clubs & Bars',  'Fashion',  'Historical / Heritage',  'Festivals',  'Art & Culture', 'Advanture Place', 'Wild Life attraction', 'Entertainment Parks', 'National Parks', 'Cliffs & Mountains', 'Waterfalls', 'Forests',  'Beaches',   'Riverside',   'Resorts',   'Invasion Sites',   'Island',   'Haunted Places', 'Exhibitions',  'Caves',  'Aquatic Ecosystem',    ]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              icon: Icon(Icons.keyboard_arrow_down, color: Colors.orange),
                              underline: Container(
                                height: 2,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),


                    // Additional field for famous food if genre is 'Food'
                    if (selectedGenre == 'Street Foods')
                      Padding(
                        padding: EdgeInsets.only(left: 26.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Is this food famous for this place?',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isFoodFamous = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: isFoodFamous ? Colors.orange : Color(0xFF263238),
                                    elevation: 0, // No shadow
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.orange, width: 2.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isFoodFamous = false;
                                      foodType = ''; // Reset the food type if not famous
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: !isFoodFamous ? Colors.orange : Color(0xFF263238),
                                    elevation: 0, // No shadow
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.orange, width: 2.0),
                                    ),
                                  ),
                                  child: Text(
                                    'No',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            if (isFoodFamous)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    'What food is it famous for?',
                                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 300,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.orange, width: 2.0),
                                      ),
                                    ),
                                    child: TextField(
                                      onChanged: (text) {
                                        setState(() {
                                          foodType = text;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'e.g., Samosa',
                                        hintStyle: TextStyle(color: Colors.white),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      style: TextStyle(color: Colors.white),
                                      maxLines: null,
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height : 35),
                          ],
                        ),
                      ),

                    // Additional field for famous fashion if genre is 'Fashion'
                    if (selectedGenre == 'Fashion')
                      Padding(
                        padding: EdgeInsets.only(left: 26.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Is this clothing famous for this place?',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isFashionFamous = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: isFashionFamous ? Colors.orange : Color(0xFF263238),
                                    elevation: 0, // No shadow
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.orange, width: 2.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isFashionFamous = false;
                                      fashionType = ''; // Reset the fashion type if not famous
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: !isFashionFamous ? Colors.orange : Color(0xFF263238),
                                    elevation: 0, // No shadow
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.orange, width: 2.0),
                                    ),
                                  ),
                                  child: Text(
                                    'No',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height : 20),
                            if (isFashionFamous)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    'What type of dress or fashion is it famous for?',
                                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 300,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.orange, width: 2.0),
                                      ),
                                    ),
                                    child: TextField(
                                      onChanged: (text) {
                                        setState(() {
                                          fashionType = text;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'e.g., Traditional attire',
                                        hintStyle: TextStyle(color: Colors.white),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      style: TextStyle(color: Colors.white),
                                      maxLines: null,
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height : 35),
                          ],
                        ),
                      ),


                    //story title for regular story
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Story Title ',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 300,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.orange, width: 2.0),
                              ),
                            ),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  storyTitle = text;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'type here ...',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),

                    //experience for regular story
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Describe Your Experience : ',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 300,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.orange, width: 2.0),
                              ),
                            ),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  experienceDescription = text;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'type here ...',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),

                    //what you love about here
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Text(
                        'What You Love About Here',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Wrap(
                        spacing: 16.0, // Horizontal spacing between buttons
                        runSpacing: 8.0, // Vertical spacing between rows of buttons
                        children: loveAboutHereOptions.map((option) {
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (selectedLoveAboutHere.contains(option)) {
                                  selectedLoveAboutHere.remove(option);
                                } else {
                                  selectedLoveAboutHere.add(option);
                                }
                                if (option == 'Others') {
                                  showOtherLoveAboutHereInput = true;
                                } else {
                                  showOtherLoveAboutHereInput = false;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: selectedLoveAboutHere.contains(option) ? Colors.orange : Color(0xFF263238),
                              elevation: 0, // No shadow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.orange, width: 2.0),
                              ),
                            ),
                            child: Text(
                              option,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (showOtherLoveAboutHereInput)
                      Padding(
                        padding: EdgeInsets.only(left: 26.0),
                        child: Row(
                          children: [
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.orange, width: 2.0),
                                ),
                              ),
                              child: TextField(
                                controller: loveAboutHereInputController,
                                onChanged: (text) {
                                  setState(() {
                                    // No need to update experienceDescription in this case
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Other Reasons',
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                style: TextStyle(color: Colors.white),
                                maxLines: null,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final newReason = loveAboutHereInputController.text;
                                if (newReason.isNotEmpty) {
                                  setState(() {
                                    // Append the new option to loveAboutHereOptions
                                    loveAboutHereOptions.add(newReason);
                                    // Update the selected option to the newly added one
                                    selectedLoveAboutHere.add(newReason);
                                    loveAboutHereInputController.clear();
                                    showOtherLoveAboutHereInput = false; // Hide the input field
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange,
                                elevation: 0, // No shadow
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                              child: Text(
                                'Add',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 35),

                    //review this place
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What you don’t like about this place? ',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 300,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.orange, width: 2.0),
                              ),
                            ),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  dontLikeAboutHere = text;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'type here ...',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),


// New input section for star rating
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Review This Place',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 300,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.orange, width: 2.0),
                              ),
                            ),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  reviewText = text;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'type here ...',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),


                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                          Text(
                            'Rate your experience here :',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox( height: 13,),
                          // Display stars based on the selected starRating
                          Row(
                            children: List.generate(5, (index) {
                              return IconButton(
                                onPressed: () {
                                  setState(() {
                                    // Set the starRating to the current index + 1
                                    starRating = index + 1;
                                  });
                                },
                                icon: Icon(
                                  index < starRating ? Icons.star : Icons.star_border,
                                  color: Colors.orange,
                                  size: 35,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),


                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Make this story' , style: TextStyle(fontSize: 18, color : Colors.white),),
                          SizedBox(height : 10),
                          Container(


                            child: Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Color(0xFF263238), // Set the background color of the dropdown here
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedVisibility,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedVisibility = newValue!;
                                      });
                                    },
                                    items: <String>['Public', 'Private']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Row(
                                          children: [
                                            // Icons for "Public" and "Private"
                                            value == 'Public'
                                                ? Icon(Icons.public, color: Colors.white)
                                                : Icon(Icons.lock, color: Colors.white),
                                            SizedBox(width: 5),
                                            Text(value, style: TextStyle(color: Colors.white)),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.orange),

                                  ),
                                ),
                              ],
                            ),
                          ),


                          SizedBox(height: 35),


                        ],
                      ),
                    ),
                  ],

                ),
              ),

              //for business development

              Visibility(
                visible: selectedLabel == 'Business Product',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [




                    // category dropdown here
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Color(0xFF263238), // Set the background color of the dropdown here
                            ),
                            child: DropdownButton<String>(
                              value: selectedaCategory,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedaCategory = newValue!;
                                });
                              },
                              items: <String>[
                                'Select1', // Ensure there's exactly one 'Select' item
                                'Furniture',
                                'Handicraft',
                                'Other',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              icon: Icon(Icons.keyboard_arrow_down, color: Colors.orange),
                              underline: Container(
                                height: 2,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    //story title here
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Story Title ',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 300,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.orange, width: 2.0),
                              ),
                            ),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  storyTitle = text;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'type here ...',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    //product description here
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Describe your product or service ',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 300,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.orange, width: 2.0),
                              ),
                            ),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  productDescription = text;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'type here ...',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    // New input section for "What You Don't Like About This Place"
                    Padding(
                      padding: EdgeInsets.only(left : 26.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Do you provide service / product at local’s door steps ?',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height : 35),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Radio button for "Yes"
                              Radio<String>(
                                value: 'Yes',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                                fillColor: MaterialStateColor.resolveWith((states) => Colors.orange),
                                // Background color when selected
                              ),
                              Text('Yes',style : TextStyle(color : Colors.white)),
                              Radio<String>(
                                value: 'No',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },

                                fillColor: MaterialStateColor.resolveWith((states) => Colors.orange),// Background color when selected
                              ),
                              Text('No',style : TextStyle(color : Colors.white)),
                            ],
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    //offered prices of your product
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Offered price of your product or Service',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),


                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                            child: Row(
                              children: [
                                // Country code dropdown
                                SizedBox(width : 5),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Color(0xFF263238), // Set the background color of the dropdown here
                                  ),
                                  child: DropdownButton<String>(
                                    value: _selectedCurrencyCode,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedCurrencyCode = newValue!;
                                      });
                                    },
                                    items: currencyCode.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(

                                          value,
                                          style: TextStyle(color: Colors.white), // Set text color to white
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(width: 5), // Add spacing between the dropdown and input field
                                // Phone number input field
                                Expanded(
                                  child: Container(
                                    child: TextField(
                                      keyboardType: TextInputType.phone,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.transparent, // Remove background color
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 16.0,
                                          horizontal: 10.0,
                                        ),
                                        hintText: 'Ex : 2250',
                                        hintStyle: TextStyle(color: Colors.white), // Set hint text color to white
                                      ),
                                      style: TextStyle(color: Colors.white), // Set text color to white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height  : 30),

                    //Delivery / transport Charges
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery / transport Charges',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 300,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.orange, width: 2.0),
                              ),
                            ),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  transportationPricing = text;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'type here ...',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    //make this story public or private
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Make this story' , style: TextStyle(fontSize: 18, color : Colors.white),),
                          Container(


                            child: Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Color(0xFF263238), // Set the background color of the dropdown here
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedVisibility,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedVisibility = newValue!;
                                      });
                                    },
                                    items: <String>['Public', 'Private']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Row(
                                          children: [
                                            // Icons for "Public" and "Private"
                                            value == 'Public'
                                                ? Icon(Icons.public, color: Colors.white)
                                                : Icon(Icons.lock, color: Colors.white),
                                            SizedBox(width: 5),
                                            Text(value, style: TextStyle(color: Colors.white)),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.orange),

                                  ),
                                ),
                              ],
                            ),
                          ),


                          SizedBox(height: 35),


                        ],
                      ),
                    ),
                    SizedBox(height  : 30),






                  ],

                ),
              ),




              //save draft or publish button


              SizedBox(height : 35),
              //for business development


            ],

          ),
        ),

      ),
      bottomNavigationBar: AnimatedContainer(
        color : Color(0xFF263238),
        duration: Duration(milliseconds: 100),
        height: _isVisible ? kBottomNavigationBarHeight + 25 : 0.0,
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              SizedBox(height : 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 156,
                    height: 63,
                    child: ElevatedButton(
                      onPressed: () async{
                        await saveDraft();
                        setState(() {
                          isSaveDraftClicked = !isSaveDraftClicked;
                          isPublishClicked = false; // Reset the other button's state
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: isSaveDraftClicked ? Colors.orange : Colors.transparent, // Change background color
                        elevation: 0, // No shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.orange, width: 2.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      ),
                      child: Text(
                        'Save Draft',
                        style: TextStyle(
                          color: isSaveDraftClicked ? Colors.white : Colors.orange, // Change text color
                          fontWeight: FontWeight.bold , // Change font weight
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 156,
                    height: 63,
                    child: ElevatedButton(
                      // onPressed: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => SavedDraftsPage()),
                      //   );
                      onPressed: () {

                        sendDataToBackend();

                        // Implement the functionality for publishing here
                        setState(() {
                          isPublishClicked = !isPublishClicked;
                          isSaveDraftClicked = false; // Reset the other button's state
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: isPublishClicked ? Colors.orange : Colors.transparent, // Change background color
                        elevation: 0, // No shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.orange, width: 2.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      ),
                      child: Text(
                        'Publish',
                        style: TextStyle(
                          color: isPublishClicked ? Colors.white : Colors.orange, // Change text color
                          fontWeight: FontWeight.bold, // Change font weight
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),


            ]
        ),
      ),

    );
  }

  @override
  void dispose() {
    super.dispose();
    _thumbnailController.dispose();
    loveAboutHereInputController.dispose();
  }
}







