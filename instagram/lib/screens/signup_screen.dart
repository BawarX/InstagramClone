
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Widgets/text_field_input.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/screens/login_Screen.dart';
import 'package:instagram/utills/colors.dart';
import 'package:instagram/utills/responsive/mobile_screen_layout.dart';
import 'package:instagram/utills/responsive/resposnive_layout_screen.dart';
import 'package:instagram/utills/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({ Key? key }) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading  = false;

void dispose(){// katek object is removed from the tree permanently.
  super.dispose();
  _emailController.dispose();
  _passwordController.dispose();
  _bioController.dispose();
  _usernameController.dispose();
}

void selectImage() async{
 Uint8List img =  await pickImage(ImageSource.gallery);
 setState(() {
   _image = img;
 });
}

void signUpUser() async{
  setState(() {
    _isLoading = true;
  });
  String res = await AuthMethods().signUpeUser(
    email: _emailController.text,
   password: _passwordController.text, 
   username: _usernameController.text, 
   bio: _bioController.text,
    file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if(res != 'success'){
        showSnackBar(res, context);
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            ), 
          ),
      );
    }
}
void navigateToLogin(){
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
      )
      );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding:const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2,),
              SvgPicture.asset('assets/ic_instagram.svg',
              color: primaryColor,
              height: 64,
              ),
              const SizedBox(height: 64),
              Stack(
                children: [
                _image != null?
                CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                 : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                      'https://www.pngarts.com/files/10/Default-Profile-Picture-PNG-Image-Transparent-Background.png'
                      ),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                   icon: const Icon(
                     Icons.add_a_photo
                     )
                     )
                     )
                ],
              ),
              const SizedBox(
                height: 24
              ),
              TextFieldInput(
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
               const SizedBox(
                height: 24
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 24
              ),  TextFieldInput(
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
               const SizedBox(
                height: 24
              ),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  child:_isLoading ? const Center(child: CircularProgressIndicator(
                    color: primaryColor,
                  ),) : const Text('Sign Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12,),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  color: blueColor
                  ),
                ),

              ),
               const SizedBox(
                  height: 12,
                ),
                Flexible(child: Container(), flex: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                   Container(
                     child: const Text('Dont have and account?'),
                     padding: const EdgeInsets.symmetric(
                       vertical: 8,
                     ),
                   ),
                     GestureDetector(
                       onTap: navigateToLogin,
                       child: Container(
                        child: Text("Login",
                         style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8
                        ),
                    ),
                     ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}