import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lookbook/Provider/google_auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:Text("Profile Screen")
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

