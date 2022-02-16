import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/Widgets/text_field_input.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/screens/signup_screen.dart';

import 'package:instagram/utills/colors.dart';
import 'package:instagram/utills/responsive/mobile_screen_layout.dart';
import 'package:instagram/utills/responsive/resposnive_layout_screen.dart';
import 'package:instagram/utills/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

void dispose(){// katek object is removed from the tree permanently.
  super.dispose();
  _emailController.dispose();
  _passwordController.dispose();
}
void loginUser()async{
  setState(() {
    _isLoading = true;
  });
  String res = await AuthMethods().loginUser(
    email: _emailController.text,
   password: _passwordController.text
   );
   if(res == 'success'){
     Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            ), 
          ),
      );
      
   }else{
     showSnackBar(res, context);
   }
   setState(() {
     _isLoading = false;
   });
}
void navigateToSignUp(){
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const SignupScreen(),
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
              ),
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading ? const Center(child: CircularProgressIndicator(
                    color: primaryColor,
                  ),) : const Text('Log in'),
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
                      child: Text("Don't have an account?"),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8
                      ),
                    ),
                     GestureDetector(
                       onTap: navigateToSignUp,
                       child: Container(
                        child: Text("Sign up", style: TextStyle(
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