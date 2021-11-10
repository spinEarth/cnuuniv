import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cnuuniv/file/login.dart';
import 'package:cnuuniv/file/Home.dart';
import 'package:cnuuniv/main.dart';


class loadingPage extends StatefulWidget {

  @override
  _loadingPageState createState() => _loadingPageState();
}

class _loadingPageState extends State<loadingPage> {
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("images/logo.jpg"),fit: BoxFit.fill)
          ],
        ),
      ),
    );
  }

  Future<void> load() async {

    if(await myinfo.load() == 1){
      print("오류가 발생했습니다.");
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    if(await myinfo.loginprepare() == 1){
      print("오류가 발생했습니다.");
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }


    if(await myinfo.login() == 1){
      print("오류가 발생했습니다.");
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

}

