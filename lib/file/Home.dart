import 'dart:convert';
import 'package:cnuuniv/file/login.dart';
import 'package:cnuuniv/file/Doit.dart';
import 'package:cnuuniv/file/myclass.dart';
import 'package:cnuuniv/main.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                      Text("https://github.com/spinEarth", style: TextStyle(color: Colors.grey, fontSize: 13), softWrap: true),
                      Text("전정통 준영이형 경민이형", style: TextStyle(color: Colors.grey, fontSize: 13), softWrap: true),
                      Text("철우형 지운이형 감사합니다.", style: TextStyle(color: Colors.grey, fontSize: 13), softWrap: true),
                    ],
                  ),
                ),
              ), //가장 아래에 회사정보 있는 곳
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(height: 60, child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey[800],
          selectedFontSize: 14,
          unselectedFontSize: 14,
          elevation: 10,
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex, //현재 선택된 Index
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              title: Text('내 강의'),
              icon: Icon(Icons.content_copy_outlined),
            ),
            BottomNavigationBarItem(
              title: Text('할 일'),
              icon: Icon(Icons.library_books_outlined),
            ),
          ],
        )),

        body:  _widgetOptions.elementAt(_selectedIndex),);
  }


  List<Widget> _widgetOptions = [
    MyClass(),
    Doit(),
  ];











}
