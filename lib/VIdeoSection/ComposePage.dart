import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:learn_flutter/CustomItems/VideoAppBar.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:math';

class ComposePage extends StatefulWidget {
  final List<String> videoPaths;

  ComposePage({required this.videoPaths});

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
  String selectedaCategory = "Select";
  String reviewText = ''; // New input for "Review This Place"
  int starRating = 0; // New input for star rating
  String selectedVisibility = 'Public';
  String liveLocation = '';


  String storyTitle = '';
  String productDescription = '';
  bool isSaveDraftClicked = false;
  bool isPublishClicked = false;
  String selectedOption = '';

  String transportationPricing = "";

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

  @override
  void initState() {
    super.initState();
    randomIndex = Random().nextInt(widget.videoPaths.length);
    _thumbnailController = VideoPlayerController.file(File(widget.videoPaths[randomIndex]))
      ..initialize().then((_) {
        setState(() {});
      });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VideoAppBar(),
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
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 26.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Differentiate this experience as ',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<String>(
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
                          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                          underline: Container(
                            height: 2,
                            color: Colors.orange,
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
=======
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
>>>>>>> safefile
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
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<String>(
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



                    //category for regular stories
                    // Padding(
                    //   padding: EdgeInsets.only(left: 26.0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Category',
                    //         style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    //       ),
                    //       DropdownButton<String>(
                    //         value: selectedCategory,
                    //         onChanged: (String? newValue) {
                    //           setState(() {
                    //             selectedCategory = newValue!;
                    //           });
                    //         },
                    //         items: <String>['Category 1', 'Category 2', 'Category 3']
                    //             .map<DropdownMenuItem<String>>((String value) {
                    //           return DropdownMenuItem<String>(
                    //             value: value,
                    //             child: Text(value, style: TextStyle(color: Colors.white)),
                    //           );
                    //         }).toList(),
                    //         icon: Icon(Icons.keyboard_arrow_down, color: Colors.orange),
                    //         underline: Container(
                    //           height: 2,
                    //           color: Colors.orange,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 20),

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
                          DropdownButton<String>(
                            value: selectedGenre,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGenre = newValue!;
                              });
                            },
                            items: <String>['Genre 1', 'Genre 2', 'Genre 3']
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
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

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
                    SizedBox(height: 20),

                    //what you love about here
                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Text(
                        'What You Love About Here',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),

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
                    SizedBox(height: 20),


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
                    SizedBox(height: 20),


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
                    SizedBox(height: 20),


                    Padding(
                      padding: EdgeInsets.only(left: 26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Make this story' , style: TextStyle(fontSize: 18, color : Colors.white),),
                          Container(


                            child: Row(
                              children: [
                                DropdownButton<String>(
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
                                              ? Icon(Icons.public, color: Colors.black)
                                              : Icon(Icons.lock, color: Colors.black),
                                          SizedBox(width: 5),
                                          Text(value, style: TextStyle(color: Colors.black)),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.orange),

                                ),
                              ],
                            ),
                          ),


                          SizedBox(height: 20),


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
                          DropdownButton<String>(
                            value: selectedaCategory,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedaCategory = newValue!;
                              });
                            },
                            items: <String>[
                              'Select', // Ensure there's exactly one 'Select' item
                              'Option 1',
                              'Option 2',
                              'Option 3',
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
                          SizedBox(height : 20),
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
                                DropdownButton<String>(
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
                                DropdownButton<String>(
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
                              ],
                            ),
                          ),


                          SizedBox(height: 20),


                        ],
                      ),
                    ),
                    SizedBox(height  : 30),






                  ],

                ),
              ),

              //save draft or publish button
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 156,
                          height: 63,
                          child: ElevatedButton(
                            onPressed: () {
                              // Implement the functionality for saving draft here
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
                            onPressed: () {
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

              SizedBox(height : 20),
              //for business development


            ],
          ),
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



void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: ComposePage(videoPaths: ['video1.mp4', 'video2.mp4']),
    ),
  ));
}
