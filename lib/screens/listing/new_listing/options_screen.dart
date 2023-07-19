import 'package:flutter/material.dart';

import 'dropdown.dart';

class OptionsScreen extends StatefulWidget {

  const OptionsScreen({Key? key}) : super(key: key);

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  String listingType="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'listingDetailsScreen');
              },
              icon: Icon(Icons.close, size: 24,),
              color: Colors.black,
            ),
        title: Text(
          "Create a new listing",
          style: TextStyle(
            color: Color(0xff0F1015),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body:    Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 5,),
            Text("What would you like to", style: TextStyle(
              color: Color(0xff2E2E2E),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),),
            Text("create a listing for?", style: TextStyle(
              color: Color(0xff2E2E2E),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),),

            GestureDetector(
              onTap: (){
                setState(() {
                  listingType="Sourcing";
                });
                Navigator.pushNamed(context, '/newlistingform', arguments: listingType);

              },
              child: Container(
                height: 70,
                width: 364,
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 5,
                  left: 26,
                  right: 24,
                ),
                decoration: BoxDecoration(
                  color: Color(0xffF8F7F7),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text("Sourcing", style: TextStyle(
                    fontSize: 20,
                  ),),
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                setState(() {
                  listingType="Collab";
                });
                // Navigator.pushNamed(context, '/newlistingform', arguments: listingType);
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return DropDown();
                }));
              },
              child: Container(
                height: 70,
                width: 364,
                margin: EdgeInsets.only(
                  left: 26,
                  right: 24,
                ),
                decoration: BoxDecoration(
                  color: Color(0xffF8F7F7),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text("Collab", style: TextStyle(
                    fontSize: 20,
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


