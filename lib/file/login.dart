import 'package:flutter/material.dart';
import 'package:cnuuniv/main.dart';
import 'package:cnuuniv/file/Home.dart';
import 'package:cnuuniv/utility.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController IDcontroller = TextEditingController();
  TextEditingController PWcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "로그인",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Column(
                    children: [
                      Image(image: AssetImage("images/logo.jpg"), fit: BoxFit.fill),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: IDcontroller,
                        decoration: InputDecoration(
                          labelText: "사이버캠퍼스 아이디",
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: PWcontroller,
                        decoration: InputDecoration(
                          labelText: "사이버캠퍼스 비밀번호",
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ButtonTheme(
                        height: 50,
                        minWidth: 200,
                        child: RaisedButton(
                            elevation: 0,
                            child: Text(
                              "로그인",
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            color: Colors.blueAccent,
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              if (await myinfo.set(IDcontroller.text, PWcontroller.text) == 1) {
                                print("1");
                                showSnackbar(context,"오류가 발생했습니다.");
                                return;
                              }
                              if (await myinfo.load() == 1) {
                                print("2");
                                showSnackbar(context,"오류가 발생했습니다.");
                                return;
                              }
                              if (await myinfo.loginprepare() == 1) {
                                print("3");
                                showSnackbar(context,"오류가 발생했습니다.");
                                return;
                              }
                              if (await myinfo.login() == 1) {
                                print("4");
                                showSnackbar(context,"오류가 발생했습니다.");
                                return;
                              }
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

}
