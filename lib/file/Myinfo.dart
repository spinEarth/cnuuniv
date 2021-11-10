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
    /*
        var param = {
         term_year: selectArr[0], //2021
         term_cd: selectArr[1], // 10은 1학기 11은 여름학기 20은 2학기
         to_do_type: todoType //“P” 왜인줄은 모름.
      }
     */
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


  Future <dynamic> myclass () async{
    /*
      var param = {
         term_year: 2021
         term_cd: 20  // 10은 1학기 11은 여름학기 20은 2학기
         is_current: Y // 왜인줄은 모름.
      }
     */
    try{
      final response = await http.post(
        Uri.parse("https://dcs-learning.cnu.ac.kr/api/v1/course/getStdMyCourseList"),
        headers: ({'content-type': 'application/x-www-form-urlencoded; charset=UTF-8', 'Cookie': '$authToken'}),
        body: ('e='+'fbdMp2SAYsnW4bl6bzFS7qJHDjZGLUojHZJRX2fWo9YfP7OR4VBUHH61d7ktkmnnlJT5k9PsSSyAjZY2MY1eFg%3D%3D'),
      );
      return response.bodyBytes;
    }
    catch(e){
      return '1';
    }
  }


  Future <dynamic> mynotice () async{
    /*
    {type: 'notice', term_cd: '20', term_year: '2021', limit: 5, offset: 0}
     */
    try{
      final response = await http.post(
        Uri.parse("https://dcs-learning.cnu.ac.kr/api/v1/board/std/notice/list"),
        headers: ({'content-type': 'application/x-www-form-urlencoded; charset=UTF-8', 'Cookie': '$authToken'}),
        body: ('e='+'GhK24SPuQxa4UvdNwexgmRQRoAIdPKu%2F8MIkxMmc54kkUTzyXydzx5iG%2BLmtJDKp%2FDAMmntDEC%2FI2%2BSHnQ5pTLuOYT28t%2BdM4zqLmF2yHPE%3D'),
      );
      return response.bodyBytes;
    }
    catch(e){
      return '1';
    }
  }

  Future <dynamic> noticedetail (Map<String, dynamic> detail) async{
    /*
        boarditem_no: "TB_L_BOARDITEM70291"
        boarditem_title: "파놉토 동영상 불러오기 오류 현상"
        class_no: "00"
        course_id: "202120UN0010392D0000000"
        course_nm: "현대인의 생활문화"
        file_yn: "N"
        insert_dt: "2021-11-08 10:43"
        no: "TB_L_BOARDITEM70291"
        open_yn: null
        read_yn: "Y"
        row_idx: 1
        rseq: 41
        term_cd: "20"
        term_cd_nm: "2학기"
        term_year: "2021"
        top_yn: "N"
        writeruserno: "201915553"
     */
    String row_idx = detail['row_idx'].toString();
    String rseq = detail['37'].toString();
    String course_id = detail['course_id'].toString();
    String course_nm = detail['course_nm'].toString();
    String class_no = detail['class_no'].toString();
    String boarditem_no = detail['boarditem_no'].toString();
    String boarditem_title = detail['boarditem_title'].toString();
    String top_yn = detail['top_yn'].toString();
    String open_yn = detail['open_yn'].toString();
    String file_yn = detail['file_yn'].toString();
    String insert_dt = detail['insert_dt'].toString();
    String writeruserno = detail['writeruserno'].toString();
    String read_yn = detail['read_yn'].toString();


    try{
      String jsonString = '{"boarditem_no":"$boarditem_no","boarditem_title":"$boarditem_title","class_no":"$class_no","course_id":"$course_id","course_nm": "$course_nm", "file_yn": "$file_yn", "insert_dt": "$insert_dt", "no": "$boarditem_no", "open_yn": "$open_yn", "read_yn": "$read_yn","row_idx": "$row_idx", "rseq": "$rseq", "term_cd": "20", "term_cd_nm": "2학기","term_year": "2021", "top_yn": "$top_yn", "writeruserno": "$writeruserno"}';
      print(jsonString);
      String AESencrypt = Uri.encodeComponent(AESencryption(jsonString));
      final response = await http.post(
        Uri.parse("https://dcs-learning.cnu.ac.kr/api/v1/board/notice/info"),
        headers: ({'content-type': 'application/x-www-form-urlencoded; charset=UTF-8', 'Cookie': '$authToken'}),
        body: ('e='+'$AESencrypt'),
      );
      return response.bodyBytes;
    }
    catch(e){
      return '1';
    }

  }




}