
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/screens/search_screen.dart';

final String placeHolderUrl = 'https://images.unsplash.com/photo-1593007791459-4b05e1158229?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80';


const webScreenSize = 600;
List<Widget> homeScreenItems = [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          Text('notif'),
          ProfileScreen(
           uid: FirebaseAuth.instance.currentUser!.uid,
           
            ),
];
