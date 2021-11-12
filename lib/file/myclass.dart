import 'dart:convert';
import 'package:cnuuniv/main.dart';
import 'package:flutter/material.dart';
import 'package:cnuuniv/utility.dart';
import 'package:cnuuniv/file/classdetail.dart';

class MyClass extends StatefulWidget {
  @override
  _MyClassState createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> {
  late List<dynamic> classlist = [];
  late List<dynamic> noticelist = [];
  late Future myFuture;

  @override
  void initState() {
    myFuture = load();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myFuture, // load() method 끝날때까지 대기
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator()); //대기 화면
          }
          return SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 30,
                    child: Text("공지사항"),
                  ),
                  Container(
                    height: classlist.length * 95,
                    child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                        itemCount: classlist.length, //배열 갯수 만큼 list 칸을 만듬
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              height: 80,
                              child: OutlineButton(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(noticelist[index]['course_nm'] + "  " + noticelist[index]['insert_dt']),
                                    Text(noticelist[index]['boarditem_title']),
                                  ],
                                ),
                                onPressed: () async {
                                  var detail = await myinfo.noticedetail(noticelist[index]);
                                  detail = jsonDecode(utf8.decode(detail));
                                  String body = detail['body']['boarditem_content'];
                                  body = body.replaceAll("<p>", "");
                                  body = body.replaceAll("</p>", "");
                                  body = body.replaceAll("<br>", "\n");
                                  showAlertDialog1(context, noticelist[index]['boarditem_title'], body);
                                },
                              ));
                        }),
                  ),

                  SizedBox(height: 15,),


                  Container(
                    height: 30,
                    child: Text("내 강의"),
                  ),


                  Container(
                    height: classlist.length * 112,
                    child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                        itemCount: classlist.length, //배열 갯수 만큼 list 칸을 만듬
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 100,
                            child: OutlineButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ClassDetail(
                                          course_id: classlist[index]['course_id'],
                                          class_no: classlist[index]['class_no'],
                                        )));

                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("강의 : " + classlist[index]['course_nm']),
                                  Text("교수 : " + classlist[index]['prof_nm']),
                                  Text("학과 : " + classlist[index]['dept_nm']),
                                  Text("전공 : " + classlist[index]['course_type']),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> load() async {
    var tmp;
    tmp = await myinfo.myclass();
    tmp = jsonDecode(utf8.decode(tmp));
    classlist = tmp['body']['course_list'];

    print(classlist);

    tmp = await myinfo.mynotice();
    tmp = jsonDecode(utf8.decode(tmp));
    noticelist = tmp['body']['list'];

    return;
  }
}
