import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void showSnackbar(BuildContext context, String comment) {
  //보여줄 메세지의 String을 input하면 됨. BuildContext context, 필요없는데 나중에 처리좀 ㅇㅇ..
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          comment,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue, //snackbar 배경색
        duration: Duration(seconds: 2), //2초동안 보여줌
      ),
    );
}


Future<String> showAlertDialog1(BuildContext context, String title, String content) async {
  String result;

  if (Platform.isIOS) {
    //ios 폰이라면
    result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(title: Text(title), content: Text(content), actions: [
          CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("예"),
              onPressed: () {
                Navigator.pop(context, "yes");
              } //아무 반응 없음
          ),
        ]);
      },
    );
  } else {
    //안드로이드일때
    result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('예'),
              onPressed: () {
                Navigator.pop(context, "yes");
              },
            ),
          ],
        );
      },
    );
  }
  return result;
}



Widget ClassType(BuildContext context, String module, String type) {
  if (module == "LV") {
    if (type == "CONTENTSTYPE_PV") {
      return Text(
        "동영상",
        style: TextStyle(backgroundColor: Colors.amberAccent),
      );
    } else if (type == "CONTENTSTYPE_W") {
      return Text(
        "웹콘텐츠",
        style: TextStyle(backgroundColor: Colors.amberAccent),
      );
    } else if (type == "CONTENTSTYPE_Z") {
      return Text(
        "ZOOM",
        style: TextStyle(backgroundColor: Colors.blueAccent),
      );
    } else if (type == "CONTENTSTYPE_U") {
      return Text(
        "유튜브",
        style: TextStyle(backgroundColor: Colors.deepOrange),
      );
    } else {
      return Text(
        "강의",
        style: TextStyle(backgroundColor: Colors.amberAccent),
      );
    }
  } else if (module == "LS") {
    return Text(
      "자료",
      style: TextStyle(backgroundColor: Colors.orange),
    );
  } else if (module == "LR") {
    return Text(
      "과제",
      style: TextStyle(backgroundColor: Colors.greenAccent),
    );
  } else {
    return Text("null");
  }
}