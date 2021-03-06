import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utills/colors.dart';
import 'package:instagram/utills/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({ Key? key }) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isloading = false;

  

  _selectImage(BuildContext context) async {
    return showDialog(context: context, builder: (context)
    {
      return SimpleDialog(
        title: const Text('create a post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Take a photo'),
            onPressed: () async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera,);
              setState(() {
                _file = file;
              });
            },
          ),
            SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Choose from gallery'),
            onPressed: () async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),
            SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
             
            },
          ),
        ],
      );
    }
    );

  }
  void postImage(
    String uid,
    String username,
    String profImage,
  )
  async{
    setState(() {
      _isloading = true;
    });
   try{
     String res = await FireStoreMethods().uploadPost(
      _descriptionController.text,
      _file!,
      uid, 
      username,
      profImage,
       );
       if(res == 'success'){
         setState(() {
           _isloading = false;
         });
         
         showSnackBar(
           context,
           'posted!'
         );
         clearImage();
       }else{
        showSnackBar(context, res);
       }
   }catch(err){
     setState(() {
       _isloading = false;
     });
   }
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
  }
@override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final UserProvider user = Provider.of<UserProvider>(context);

    return _file == null 
    ? Center(
      child: IconButton(
        icon: Icon(
          Icons.upload
        ),
        onPressed: () => _selectImage(context),
      ),
    )
    :Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: const Text('Post to'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => postImage(
            UserProvider().getUser.uid!, 
            UserProvider().getUser.username!,
            UserProvider().getUser.photoUrl!,
             ),
             child: const Text(
            'post ',
            style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
          )
          )
        ],
      ),
      body: Column(
        children: [
          _isloading? const LinearProgressIndicator() : 
          const Padding(
            padding: EdgeInsets.only(top:0.0),
            ),
            const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  // lerash errorak haya nazanm ku chak dakre

                  //UserProvider.getUser.photoUrl,
                  ''
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.45,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'write a caption...',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/251,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                       
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        image: MemoryImage(_file!),
                        ),
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ],
      ),
    );
  }
}