import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cnuuniv/main.dart';

class ClassDetail extends StatefulWidget {
  final String course_id;
  final String class_no;

  ClassDetail({required this.course_id, required this.class_no});

  @override
  _ClassDetailState createState() => _ClassDetailState();
}

class _ClassDetailState extends State<ClassDetail> {
  late List<dynamic> classdata = [];

  late Future myFuture;

  @override
  void initState() {
    myFuture = load();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("hi"),
        ),
        body: FutureBuilder(
            future: myFuture, // load() method 끝날때까지 대기
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator()); //대기 화면
              }
              return Container(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: classdata.length, //notice_list 길이만큼 List를 만듬
                    itemBuilder: (BuildContext context, int index) {
                      //예를 들어 5개를 만들면 index는 0~4까지 생성됨
                      int num = index + 1;
                      List<dynamic> temp = [];

                      for (int i = 0; i < classdata[index]['seq_list'].length; i++) {
                        for (int j = 0; j < classdata[index]['seq_list'][i]['learning_list'].length; j++) {
                          temp.add(classdata[index]['seq_list'][i]['learning_list'][j]);
                        }
                      }
                      return ExpansionTile(
                        title: Text("$num주차"), //공지 제목 부분
                        children: [
                          Container(
                              height: temp.length * 100.0,
                              child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                itemCount: temp.length, //notice_list 길이만큼 List를 만듬
                                itemBuilder: (BuildContext context, int index2) {
                                  //예를 들어 5개를 만들면 index는 0~4까지 생성됨
                                  String date = temp[index2]['weekseq_str_dt'] + " ~ " + temp[index2]['weekseq_end_dt'];
                                  String type = temp[index2]['contents_type'];
                                  String module = temp[index2]['module_type'];
                                  return Container(
                                    height: 100,
                                    child: OutlineButton(
                                      onPressed: () {
                                        print(temp[index2]);
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Wrap(
                                            children: [
                                              buildtest(context, module, type),
                                              Text(
                                                "  " + temp[index2]['weekseq_nm'],
                                              )
                                            ],
                                          ),
                                          Text(date),
                                        ],
                                      ),
                                    ),
                                  ); //펼쳐지는 타일 클래스
                                },
                              ))

                          //누르면 펴지는 곳 (공지 내용)
                        ],
                      ); //펼쳐지는 타일 클래스
                    },
                  ));
            }));
  }

  /*

   */

  Future<void> load() async {
    int i, j, k;
    k = 0;

    var tmp;
    tmp = await myinfo.classload(widget.course_id, widget.class_no);
    tmp = jsonDecode(utf8.decode(tmp));

    var tmp2;
    var tmp3;


    for (i = 0; i < tmp['body']['week_list'].length; i++) {
      classdata.add(tmp['body']['week_list'][i]);
    }

    /*
          for (j = 0; j < tmp['body']['week_list'][i]['seq_list'].length; j++) {
        classdata.add(tmp['body']['week_list'][i]['seq_list'][j]['learning_list']);
      }

         for (i = 0; i < tmp['body']['week_list'].length; i++) {
      classdata.add(tmp['body']['week_list'][i]['seq_list'][j]);
    }
     */
    return;
  }
}

Widget buildtest(BuildContext context, String module, String type) {
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
      return Text("null");
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

/*




 */
