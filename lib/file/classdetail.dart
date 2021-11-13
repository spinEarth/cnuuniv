import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cnuuniv/main.dart';
import 'package:cnuuniv/utility.dart';
import 'package:cnuuniv/file/Panopto.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassDetail extends StatefulWidget {
  final String course_id;
  final String class_no;
  final String class_name;

  ClassDetail({required this.course_id, required this.class_no, required this.class_name});

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
          elevation: 0,
          title: Text(
            widget.class_name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
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
                                        if(temp[index2]['contents_type'] == "CONTENTSTYPE_PV"){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Panopto(
                                                    content_url: temp[index2]['contents_url'],
                                                  )));
                                        }
                                        if(temp[index2]['contents_type'] == "CONTENTSTYPE_W" || temp[index2]['contents_type'] == "CONTENTSTYPE_Z" || temp[index2]['contents_type'] == "CONTENTSTYPE_U"){
                                            launch(temp[index2]['contents_url']);
                                        }


                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Wrap(
                                            children: [
                                              ClassType(context, module, type),
                                              Text(
                                                "  " + temp[index2]['weekseq_nm'],
                                              )
                                            ],
                                          ),
                                          Text(date),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              temp[index2]['complete_yn'] == "Y"?
                                              Text("완료", style: TextStyle(backgroundColor: Colors.lightBlue),):
                                              Text("미완료", style: TextStyle(backgroundColor:Colors.deepOrangeAccent),),

                                              SizedBox(width: 10,),


                                              temp[index2]['lv_complete_rst'] != null?
                                              Text((int.parse(temp[index2]['lv_complete_rst'])/60).toStringAsFixed(0) +"분"+" / "+temp[index2]['study_time'].toString() + "분"):
                                              Text(temp[index2]['study_time'].toString() + "분"),
                                            ],
                                          )

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

  Future<void> load() async {
    var tmp;
    tmp = await myinfo.classload(widget.course_id, widget.class_no);
    tmp = jsonDecode(utf8.decode(tmp));

    for (int i = 0; i < tmp['body']['week_list'].length; i++) {
      classdata.add(tmp['body']['week_list'][i]);
    }

    return;
  }

}