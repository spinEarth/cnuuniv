import 'dart:convert';
import 'package:cnuuniv/file/login.dart';
import 'package:cnuuniv/main.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "국립 충남대학교",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        drawer: Drawer(
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      myinfo.id! + "님 환영합니다.",
                      style: TextStyle(fontSize: 17),
                    ),
                    accountEmail: Text(
                      "",
                      style: TextStyle(fontSize: 60),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))), //박스 색과 테두리 둥글게 만든 곳
                  ), //상단 유저 정보 부분
                  Container(
                    height: 300,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      //리스트가 위 아래로 안움직이게 고정
                      padding: EdgeInsets.zero,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.logout,
                            size: 30,
                          ),
                          title: Text("로그아웃"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                            myinfo.logout();
                          },
                        ),
                      ],
                    ), //리스트 부분
                  ),
                ],
              ), //각종 설정 밑 유저 데이터 있는 곳
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  child: Column(
                    children: [
                      Text("https://github.com/spinEarth", style: TextStyle(color: Colors.grey, fontSize: 11), softWrap: true),
                      Text("전전통 준영이형 경민이형 감사합니다.", style: TextStyle(color: Colors.grey, fontSize: 11), softWrap: true),
                    ],
                  ),
                ),
              ), //가장 아래에 회사정보 있는 곳
            ],
          ),
        ),
        body: FutureBuilder(
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
                  Divider(thickness: 1, height: 1,),
                  Container(
                    height:  MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - AppBar().preferredSize.height - 61,
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
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5,),
                                  Text("강의명 : " + homework[index]['item_title_temp'] + "  |  "+ check(homework[index]['module_type'])),
                                  Text("강좌명 : " + homework[index]['course_nm']),
                                  Text("최종기한 : " + homework[index]['info']),
                                  SizedBox(height: 5,),
                                ],
                              ),
                            );
                          }),
                      //위로 당겨지면 뜨는 글자 설정
                    ),
                  ),
                ],
              );
            }));
  }

  Future<void> load() async {
    var tmp;
    tmp = await myinfo.homework();
    tmp = jsonDecode(utf8.decode(tmp));
    homework = tmp['body']['todo_list'];
    print(homework);
    return;
  }

  void _onRefresh() async{
    await load();
    setState(() {
    });
    _refreshController.refreshCompleted();
  }

  String check(String value){
    if(value == "LR"){
      return "과제";
    }
    else if(value == "LS"){
      return "자료";
    }
    else if(value == "LV"){
      return "강의";
    }
    else{
      return "null";
    }
  }


  void date(){
    for(var i =0; i<homework.length; i++){
      for(var j =0; j<homework.length -1 ; j++){
        if(DateTime.parse(homework[j]['info']).compareTo(DateTime.parse(homework[j+1]['info'])) > 0 ){
            var temp = homework[j];
            homework[j] = homework[j+1];
            homework[j+1] = temp;
        }

      }
    }
    setState(() {
    });
  }


}
