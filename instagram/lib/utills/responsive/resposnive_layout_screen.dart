import 'package:flutter/material.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/utills/global_variable.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  
  final Widget mobileScreenLayout;

  const ResponsiveLayout({ Key? key, required this.mobileScreenLayout }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

@override
  void initState() {
    super.initState();
    addData();
  }
  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);//one time view
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,contraints){
        // if(contraints.maxWidth > webScreenSize){
        // return webScreenLayout;
        // }
        return widget.mobileScreenLayout;
      },
    );
  }
}