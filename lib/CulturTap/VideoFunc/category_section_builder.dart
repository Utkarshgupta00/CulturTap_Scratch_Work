import 'package:flutter/material.dart';
import 'package:learn_flutter/CulturTap/StoryDetailPage.dart';
import 'package:learn_flutter/CulturTap/VideoFunc/video_story_card.dart';



Widget buildCategorySection( String specificCategoryName, String categoryName, List<String> storyUrls, List<String> videoCounts, List<String> storyDistance, List<String> storyLocation, List<String> storyCategory, List<Map<String, dynamic>> storyDetailsList) {
  // Check if the category has videos
  if (storyUrls.isEmpty || storyDistance.isEmpty) {
    // Don't display anything for categories with no videos
    return Column(children: [


    ],);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left:18.0,right:18,top:18,bottom:10),
        child: Column(
          children: [
            if (specificCategoryName != null && specificCategoryName.isNotEmpty)
              Text(
                specificCategoryName,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF263238),),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  categoryName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,  color: Color(0xFF263238),),
                ),
                TextButton(
                  onPressed: () {
                    // Handle button press for "View All" in the specific category
                  },
                  child: Text(
                    'View All >',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        height: 590,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: storyUrls.length,
          itemBuilder: (context, index) {

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryDetailPage(
                      storyUrls: storyUrls,
                      storyDetailsList: storyDetailsList,
                      initialIndex: index,
                    ),
                  ),
                );

              },
              child: VideoStoryCard(
                videoUrl: storyUrls[index],
                distance: storyDistance[index],
                videoCount: videoCounts[index],
                location : storyLocation[index],
                category : storyCategory[index],

              ),
            );
          },
        ),
      ),

    ],
  );
}

