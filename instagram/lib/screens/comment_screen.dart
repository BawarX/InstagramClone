
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Widgets/comment_card.dart';
import 'package:instagram/model/user.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utills/colors.dart';
import 'package:instagram/utills/utils.dart';
import 'package:provider/provider.dart';

// class CommentsScreen extends StatefulWidget {
//   final snap;
//   const CommentsScreen({ Key? key, required this.snap }) : super(key: key);

//   @override
//   _CommentsScreenState createState() => _CommentsScreenState();
// }

// class _CommentsScreenState extends State<CommentsScreen> {
//   final TextEditingController _commentcontroller = TextEditingController();
//   @override
//   void dispose() {
//     super.dispose();
//     _commentcontroller.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final User user = Provider.of<UserProvider>(context).getUser;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         title: const Text('comments'),
//         centerTitle: false,
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.
//         collection('posts').
//         doc(widget.snap['postId']).
//         collection('comments')
//         .orderBy('datePublished',descending: true )
//         .snapshots(),
//         builder: (context, snapshot){
//           if(snapshot.connectionState == ConnectionState.waiting){
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           return ListView.builder(
//             itemCount: (snapshot.data! as dynamic).docs.length,
//             itemBuilder: (context, index) => CommentCard(
//               snap: (snapshot.data! as dynamic).docs[index].data()
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: SafeArea(
//        child: Container(
//          height: kToolbarHeight,
//          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom
//          ),
//          padding: const EdgeInsets.only(left:16, right: 8),
//          child: Row(
//            children: [
//              CircleAvatar(
//                backgroundImage: NetworkImage(
//                  user.photoUrl!,
//                ),
//                radius: 18,
//              ),
//              Expanded(
//                child: Padding(
//                  padding: const EdgeInsets.only(left: 16, right: 8.0),
//                  child: TextField(
//                   controller: _commentcontroller,
//                    decoration: InputDecoration(
//                      hintText: 'comments as  ${user.username}',
//                      border: InputBorder.none,
//                    ),
//                  ),
//                ),
//              ),
//              InkWell(
//                onTap: ()async{
//                await  FirestoreMethods().postComment(
//                  widget.snap['postId'], 
//                 _commentcontroller.text,
//                  user.uid!, 
//                  user.username!, 
//                  user.photoUrl!
//                  );
//                  setState(() {
//                    _commentcontroller.text = '';
//                  });
               
//                },

//                child: Container(
//                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal:  8),
//                  child: const Text('Post',style: TextStyle(
//                    color: blueColor,
//                  ),) ,
//                ),
//              )
//            ],
//          ),
//        ),
//       ),
//     );
//   }
// }

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId, required String snap}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreMethods().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1640622842924-fb0017b9d786?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=872&q=80'
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  user.uid!,
                  user.username!,
                  user.photoUrl!,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}