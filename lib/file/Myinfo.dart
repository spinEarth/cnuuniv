import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_scraper/web_scraper.dart';
import 'package:cnuuniv/file/encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Myinfo{
  String? id;
  String? pw;
  String? jsessionId;
  String? authToken;
  String? RsaKey;

  Myinfo(){
    print("initialize");
  }


  Future<int> set (String idinput, String pwinput) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs = await SharedPreferences.getInstance();
      _prefs.setString('id', idinput);
      _prefs.setString('pw', pwinput);
      return 0;
    }
    catch (e) {
      return 1;
    }
  }


  void logout ()async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs = await SharedPreferences.getInstance();
    _prefs.remove('id');
    _prefs.remove('pw');
  }



  Future<int> load() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    id = await (_prefs.getString('id') ?? 'null');
    pw = await (_prefs.getString('pw') ?? 'null');

    if (id == 'null' || pw == 'null') {
      return 1;
    }
    return 0;
  }

  Future<int> loginprepare() async{
    String tmp;

    try {
      final response = await http.get(
          Uri.parse("https://dcs-lcms.cnu.ac.kr/login?redirectUrl=https://dcs-learning.cnu.ac.kr/")
      );
      tmp = response.headers['set-cookie'].toString();
      print(tmp);
      tmp = tmp.replaceRange(0, (tmp.indexOf(',') + 1), '');
      jsessionId = tmp.replaceRange((tmp.indexOf(';') + 1), tmp.length, '');
      tmp = utf8.decode(response.bodyBytes);

      final webScraper = WebScraper();
      if (await webScraper.loadFromString(tmp)) {
        List<Map<String, dynamic>> elements = webScraper.getElement('div.fieldArea > form > input', ['value']);
        RsaKey = elements[1]['attributes']['value'].toString();
        print(RsaKey);
      }
      return 0;
    }
    catch(e){
      return 1;
    }

  }




  Future<int> login() async{
    try{
      String RSApw = await RSAencrytion(pw!, RsaKey!);
      String jsonString = '{"redirect_url": "https://dcs-learning.cnu.ac.kr/","key": "$RsaKey","univ_no": "CNU","user_id": "$id","user_password": "$RSApw"}';
      String AESencrypt = Uri.encodeComponent(AESencryption(jsonString));
      print(AESencrypt);


      print(jsessionId);
      final response = await http.post(
        Uri.parse("https://dcs-lcms.cnu.ac.kr/api/v1/user/login"),
        headers: ({'content-type': 'application/x-www-form-urlencoded; charset=UTF-8', 'Cookie':'$jsessionId'}),
        body: ('e='+'$AESencrypt'),
      );

      var jsondata = await jsonDecode(response.body);
      print(jsondata);
      if(jsondata['header']['msg'] != "OK"){
        return 1;
      }
      String tmp = response.headers['set-cookie'].toString();
      tmp = tmp.replaceRange(0, (tmp.indexOf('AUTH-TOKEN')), '');
      authToken = tmp.replaceRange((tmp.indexOf(';')), tmp.length, '');
      print(authToken);
      return 0;
    }
    catch(e){
      return 1;
    }
  }

  Future <dynamic> homework () async{
    try{
      final response = await http.post(
        Uri.parse("https://dcs-learning.cnu.ac.kr/api/v1/week/getStdTodoList"),
        headers: ({'content-type': 'application/x-www-form-urlencoded; charset=UTF-8', 'Cookie': '$authToken'}),
        body: ('e='+'KFvMQEoHCB52Y6z06Y6FeIJ83sKYe3rzCXLu2vXQ3L2rKp1kZ98buDl2Yj9dFb70L0PA1wEmlUgzBJCrMhaYdw=='),
      );
      return response.bodyBytes;
    }
    catch(e){
      return '1';
    }

  }


}