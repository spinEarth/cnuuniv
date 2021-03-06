import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cnuuniv/main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cnuuniv/utility.dart';

class Doit extends StatefulWidget {
  @override
  _DoitState createState() => _DoitState();
}

class _DoitState extends State<Doit> {
  late List<dynamic> homework = [];
  late Future myFuture;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

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
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
                      child: OutlinedButton(
                        onPressed: () {
                          _onRefresh();
                        },
                        child: Text("기본순"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
                      child: OutlinedButton(
                        onPressed: () {
                          date();
                        },
                        child: Text("날짜순"),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                height: 1,
              ),
              Container(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - AppBar().preferredSize.height - 125,
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: false,
                  onRefresh: _onRefresh,
                  header: ClassicHeader(
                    idleText: "",
                    completeText: "",
                    releaseText: "",
                    refreshingText: "",
                  ),
                  child: ListView.separated(
                      padding: EdgeInsets.all(10),
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                      itemCount: homework.length, //배열 갯수 만큼 list 칸을 만듬
                      itemBuilder: (BuildContext context, int index) {
                        return OutlineButton(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Wrap(
                                  children: [
                                    ClassType(context, homework[index]['module_type'], ""),
                                    Text(" : " + homework[index]['item_title_temp'])
                                  ],
                                ),

                                homework[index]['week_no'] != null?
                                Text("강좌 : " + homework[index]['course_nm'] + " " + homework[index]['week_no'].toString() + "주차"):
                                Text("강좌 : " + homework[index]['course_nm']),

                                Text("최종기한 : " + homework[index]['info']),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                            onPressed: () {
                              print(homework[index]);
                            });
                      }),
                  //위로 당겨지면 뜨는 글자 설정
                ),
              ),
            ],
          );
        });
  }

  Future<void> load() async {
    var tmp;
    tmp = await myinfo.homework();
    tmp = jsonDecode(utf8.decode(tmp));
    homework = tmp['body']['todo_list'];
    return;
  }

  void _onRefresh() async {
    await load();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void date() {
    for (var i = 0; i < homework.length; i++) {
      for (var j = 0; j < homework.length - 1; j++) {
        if (DateTime.parse(homework[j]['info']).compareTo(DateTime.parse(homework[j + 1]['info'])) > 0) {
          var temp = homework[j];
          homework[j] = homework[j + 1];
          homework[j + 1] = temp;
        }
      }
    }
    setState(() {});
  }
}
