
import 'package:flutter/material.dart';
import 'package:instagram/Widgets/comment_card.dart';
import 'package:instagram/utills/colors.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({ Key? key }) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('comments'),
        centerTitle: false,
      ),
      body: CommentCard(),
      bottomNavigationBar: SafeArea(
       child: Container(
         height: kToolbarHeight,
         margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom
         ),
         padding: const EdgeInsets.only(left:16, right: 8),
         child: Row(
           children: [
             CircleAvatar(
               backgroundImage: NetworkImage(
                 'https://images.unsplash.com/photo-1645095540131-ef6f8d8126da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
               ),
               radius: 18,
             ),
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.only(left: 16, right: 8.0),
                 child: TextField(
                   decoration: InputDecoration(
                     hintText: 'comments as  username',
                     border: InputBorder.none,
                   ),
                 ),
               ),
             ),
             InkWell(
               onTap: (){},
               child: Container(
                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal:  8),
                 child: const Text('Post',style: TextStyle(
                   color: blueColor,
                 ),) ,
               ),
             )
           ],
         ),
       ),
      ),
    );
  }
}