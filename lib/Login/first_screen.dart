import 'package:flutter/material.dart';
import 'login_options.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_){
            return LoginOptions();
          }));
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset("assets/indexImg.png", height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
