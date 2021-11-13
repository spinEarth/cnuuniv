import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Panopto extends StatefulWidget {
  final String content_url;
  Panopto({required this.content_url});

  @override
  _PanoptoState createState() => _PanoptoState();
}

class _PanoptoState extends State<Panopto> {
  late Future myFuture;
  late WebViewController _controller;
  late String id;


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
            "Panopto",
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
              return SafeArea(
                child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) async{
                    _controller = webViewController;
                    _controller.loadUrl('https://cnu.utime.kr/wp/wp-login.php?action=wp-saml-auth&EID_SP=cnu-panopto&SSO_USER=$id&SSO_PASS=$id'+'123!');
                    while(true){
                      if (await _controller.currentUrl() == "https://cnu.ap.panopto.com/Panopto/Pages/Home.aspx"){
                        _controller.loadUrl(widget.content_url);
                        break;
                      }
                    }

                  },
                ),
              );
            }));
  }


  Future<void> load() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    id = await (_prefs.getString('id') ?? 'null');
  }

}
