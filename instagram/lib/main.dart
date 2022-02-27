import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Widgets/post_card.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/resposnive_layout_screen.dart';
import 'package:instagram/screens/login_Screen.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utills/colors.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget build(BuildContext context){
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider(),
      )
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
    
      home:FirebaseAuth.instance.currentUser == null ? SignupScreen() : 
        MobileScreenLayout(),

    ),
  );
  }
}