import 'package:cnuuniv/file/Myinfo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cnuuniv/file/loadingPage.dart';



final myinfo = new Myinfo();





void main() async{
  //runApp(MyApp을 제외하고는 전부 화면 가로로 못 눕이게 세로 고정 박는 코드)
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

}

class MyApp extends StatelessWidget {



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //홈으로 갑세~
      home: loadingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
