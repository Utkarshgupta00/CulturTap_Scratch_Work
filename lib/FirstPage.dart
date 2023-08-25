import 'package:flutter/material.dart';
import 'package:learn_flutter/SecondPage.dart';

void main() {
  runApp(const FirstPage());
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: Colors.black,

          secondary: Colors.white,

          surface: Colors.white,
          background: Colors.white,
          error: Colors.red,
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.red,
          brightness: Brightness.light,
        ),

        useMaterial3: true,
      ),
      home: Center(
        child: const MyHomePage(title: 'LogIn'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var nameText = TextEditingController();
  bool validate = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Center(
          child: Container(
            width : 156,
              height : 48.6,
              child : Image.asset('assets/images/logo.png')),
        ),
      ),

      body: Container(
        width : double.infinity,
        height : double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width : 325,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 35),
                    child : Image.asset('assets/images/firstPage.png'),
                    height: 268,
                    width : 389,
                    color: Colors.white,
                  ),
                  Text('SIGNUP',
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  Container(
                      margin: EdgeInsets.only(bottom: 31),
                      child: Text('Explore, Update, Guide & Earn !',
                          style: TextStyle(fontSize: 25, color: Colors.black))),
                  Text('Please Enter Your Name',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),


                  Container(
                    height : 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: 324,
                    height : 54,
                    child: TextField(
                      controller: nameText,
                      decoration: InputDecoration(
                        hintText: 'Ex : Kishor Kumar',
                          filled: true,
                          fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none, // No border
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 21),
                    child: Row(
                      children: [
                        Text('Already User ?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w100)),
                        TextButton(
                          onPressed: () {
                            // TODO: Add navigation to Sign In page
                          },
                          child: Text('Sign In',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w900,
                                fontSize: 25,
                              )),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 330,
                    height: 70,
                    child: FilledButton(
                        backgroundColor: Colors.orange,
                        onPressed: () {
                          String Name = nameText.text.toString();
                          print('Name  : ${Name} ');
                          if(Name.length > 2){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SecondPage(
                                  phoneNumberController: TextEditingController(),
                                ),
                              ),
                            );
                          };

                        },
                        child: Center(
                            child: Text('Next',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 25)))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FilledButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final Color backgroundColor;

  const FilledButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
      ),
      child: child,
    );
  }
}