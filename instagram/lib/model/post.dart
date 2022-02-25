import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String descritption;
  final String uid;
  final String username;
  final String postId;
  //final String datePublished;
   final String postUrl;
   final String profImage;
   final likes;

  const Post({
    required this.descritption,
    required this.uid,
    required this.username,
    required this.postId,
    //required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes
  });

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        username: snapshot['username'],
        uid: snapshot['uid'],
        descritption: snapshot['description'],
        postId: snapshot['postId'],
     //  datePublished: snapshot['datePublished'],
        profImage:snapshot['profImage'],
        likes: snapshot['likes'],
        postUrl: snapshot['postUrl'],

    );
  }
    Map<String,dynamic> toJson() => {
    'description':descritption,
    'uid':uid,
    'username': username,
    'postId': postId,
    //'datePublished': datePublished,
    'profImage': profImage,
     'likes': likes,
     'postUrl': postUrl,
  };
}