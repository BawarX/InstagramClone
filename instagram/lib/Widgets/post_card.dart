import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Widgets/like_animation.dart';
import 'package:instagram/model/user.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/screens/comment_screen.dart';
import 'package:instagram/utills/colors.dart';
import 'package:instagram/utills/utils.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  @override
  void initState() {
  super.initState();
  
  fetchCommentLen();
  }
  void fetchCommentLen() async {
    try{
  QuerySnapshot snap =   await FirebaseFirestore.instance
  .collection('posts')
  .doc(widget.snap['postId'])
  .collection('comments')
  .get();
  commentLen = snap.docs.length;
    }catch(err){
      showSnackBar(
       context,
       err.toString(),
         );
    }
    setState(() {
      
    });
  }
  deletePost(String postId) async {
    try{
      await FireStoreMethods().deletePost(postId);
    }catch(err){
      showSnackBar(context, err.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    final User user  = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage']
                     ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'username',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shrinkWrap: true,
                          children: [
                            'Delete',
                          ]
                              .map(
                                (e) => InkWell(
                                  onTap: ()  async {
                                    FireStoreMethods().deletePost(widget.snap['postId']);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.more_vert),
                )
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async{
           
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children:[ 
                SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                widget.snap['postUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating? 1:0,
                child: LikeAnimation(
                  child: const Icon(Icons.favorite, 
                color:Colors.white, 
                size: 120,),
                 isAnimating: isLikeAnimating,
                 duration: const Duration(
                   microseconds: 400,
                 ),
                 onEnd: (){
                   setState(() {
                     isLikeAnimating = false;
                   });
                 } ,
                 ),
              )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async{
              await  FireStoreMethods().likePost(
                widget.snap['postId'],
                user.uid!,
                widget.snap['likes']
              );
                  },
                  icon:  widget.snap['likes'].contains(user.uid) ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ): const Icon(Icons.favorite_border,),
                ),
              ),
                IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentsScreen(
                 snap: widget.snap['postId'].toString(),
                  postId: null,
                ),
                ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                
                ),
              ),
                  IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
               
              ),
               Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      onPressed: (){},
                    ),
                  ),
                ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['likes'].length}',
                       style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: primaryColor
                        ),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold,),
                          ),
                          TextSpan(
                            text: widget.snap['description'],
                            style: const TextStyle(fontWeight: FontWeight.bold,),
                          ),
                        ]
                      ),
                    ),
                  )
                ],
              ),
          ),
          InkWell(
            onTap: (){},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                widget.snap['datePublished'],
                 style:
                 const TextStyle(
                      fontSize: 16, color: secondaryColor
              ),
              ),
            ),
            
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
               'View all $commentLen comments',
                 style:
                 const TextStyle( fontSize: 16, color: secondaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
