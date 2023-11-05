// profile header section -- state1
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/ServiceSections/TripCalling/Pings.dart';

import '../widgets/01_helpIconCustomWidget.dart';
import '../widgets/hexColor.dart';


// AppBar Section
class ProfileHeader extends StatefulWidget {
  final int reqPage;
  final String? imagePath;
  final String? userId;
  ProfileHeader({required this.reqPage,this.imagePath,this.userId});
  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}
class _ProfileHeaderState extends State<ProfileHeader> {
  // notification count will be made dynamic from backend
  int notificationCount = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: Colors.red,
      //     width: 2,
      //   ),
      // ),
      height: 92,
      padding: EdgeInsets.only(top: 20.0,left: 15.0,right: 15.0,bottom:15.0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.reqPage<1?
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Handle profile image click
                },
                child: Container(
                  // width: 100,
                  height: 35,
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: widget.imagePath != null
                        ? FileImage(File(widget.imagePath!)) as ImageProvider<Object>?
                        : AssetImage('assets/images/profile_image.jpg'), // Use a default asset image
                  ),
                ),
              ),
              Text('Profile',style: TextStyle(fontSize: 14,color:HexColor("#FB8C00"),fontWeight: FontWeight.w900,fontFamily: 'Poppins',),),
            ],
          ):
          Container(
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Colors.black,
            //     width: 2,
            //   ),
            // ),
            width: 60,
            height: 45,
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Image.asset('assets/images/back.png',width: 60,height: 30,),
              ),
            ),
          ),
          widget.reqPage>=1?
          Padding(
            padding:EdgeInsets.only(top: 13.0),
            child:Align(
              alignment: Alignment.topLeft,
              child: Image.asset('assets/images/logo.png',width: 145),
            ),
          ):Padding(
            padding:EdgeInsets.only(top: 13.0,right: 12,),
            child:Align(
              alignment: Alignment.topLeft,
              child: Image.asset('assets/images/logo.png',width: 145),
            ),
          ),
          widget.reqPage<=1?
          Column(
            children: [
              InkWell(
                onTap: (){
                  if(widget.userId!=null){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PingsSection(userId: widget.userId!,),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 55,
                  height: 35,
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     color: Colors.orange,
                  //     width: 2,
                  //   ),
                  // ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 6.0,right: 4.0),
                        child: Image.asset('assets/images/ping_image.png',height: 28 ,fit: BoxFit.cover,
                        ),
                      ),
                      if(notificationCount>0)
                        Positioned(
                          top: -6,
                          right: 0,
                          // height: 20,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              notificationCount.toString(),
                              style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w800,fontFamily: 'Poppins'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Text('Pings',style: TextStyle(fontSize: 14,color:Colors.black,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
            ],
          ):
          Container(
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Colors.black,
            //     width: 2,
            //   ),
            // ),
            width: 60,
            height: 45,
            child: Align(
              alignment: Alignment.topCenter,
              child: widget.reqPage==4?GestureDetector(
                onTap: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return Container(child: CustomHelpOverlay(imagePath: 'assets/images/icon.jpg',serviceSettings: false,),);
                  },
                  );
                },
                child: Image.asset('assets/images/skip.png',width: 60,height: 30,),
              ):SizedBox(width: 0,),
            ),
          ),
        ],
      ),
    );
  }
}

