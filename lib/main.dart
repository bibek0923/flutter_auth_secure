import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:try_app/src/core/services/token_storeage.dart';

import 'package:try_app/src/features/auth/presentation/pages/login_page_wrapper.dart';
import 'package:try_app/src/features/site_listing/presentation/pages/homepageWrapper.dart';
import 'package:try_app/src/injection/injection_container.dart';


void main() async{
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  final loginStatus= await sl<TokenStorage>().getLoginStatus() ;

  runApp(MyApp(loginStatus: loginStatus!,));
}

class MyApp extends StatelessWidget {
 const   MyApp({super.key , required this.loginStatus});
final  bool loginStatus;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:  loginStatus ? Homepagewrapper() :  LoginPageWrapper(),

      
    );
  }
}








