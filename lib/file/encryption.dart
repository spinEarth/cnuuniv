import 'package:encrypt/encrypt.dart';
import 'package:simple_rsa2/simple_rsa2.dart';

String AESencryption(String plainText) {

  final key = Key.fromUtf8('dJoviA4NUgrSM73R5uIrNaJtPCd1zA78');
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted.base64;
}

Future<String> RSAencrytion(String plainText,String RSAKey) async{
  final encryptedText = await encryptString(plainText, RSAKey);
  print(encryptedText);
  return encryptedText.replaceAll('\n', '');
}