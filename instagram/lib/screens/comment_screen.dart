
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Widgets/comment_card.dart';
import 'package:instagram/model/user.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utills/colors.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({ Key? key, required this.snap }) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentcontroller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentcontroller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.
        collection('posts').
        doc(widget.snap['postId']).
        collection('comments').
        snapshots(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => CommentCard(
              
            ),
          );
        },
      ),
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
                 user.photoUrl,
               ),
               radius: 18,
             ),
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.only(left: 16, right: 8.0),
                 child: TextField(
                  controller: _commentcontroller,
                   decoration: InputDecoration(
                     hintText: 'comments as  ${user.username}',
                     border: InputBorder.none,
                   ),
                 ),
               ),
             ),
             InkWell(
               onTap: ()async{
               await  FirestoreMethods().postComment(
                 widget.snap['postId'], 
                _commentcontroller.text,
                 user.uid , 
                 user.username, 
                 user.photoUrl);
                 setState(() {
                   _commentcontroller.text = '';
                 });
               
               },

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