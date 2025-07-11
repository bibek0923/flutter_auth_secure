import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class  TokenStorage {
static const _accessTokenKey = "ACCESS_TOKEN";
static const _refreshTokenKey = "REFRESH_TOKEN";
static const _isLoggedIn = "is_logged_in";
// bool isLoggedIn = false;
final FlutterSecureStorage _storage = const FlutterSecureStorage();

Future <void> saveTokens (String access , String refresh) async{
  print("tokens are being saved");
  await _storage.write(key: _accessTokenKey, value: access);
  await _storage.write(key: _refreshTokenKey, value: refresh);
  // isLoggedIn=true;
  // print("user login status is now $isLoggedIn");
  await _storage.write(key: _isLoggedIn, value: "true");
  

}

Future<String?> getAccessToken ()=>_storage.read(key: _accessTokenKey);
Future<String?> getRefreshToken ()=>_storage.read(key: _refreshTokenKey);
Future<bool?> getLoginStatus () async {
 final loggedinStatus=  await _storage.read(key: _isLoggedIn);
 if(loggedinStatus=="true"){
  return  true;
 }
else {
   return false;
 }
}

Future<void> clearTokens()async{
await   _storage.deleteAll();
}
}