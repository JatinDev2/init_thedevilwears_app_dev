import 'package:flutter/material.dart';

import 'dropdown.dart';

class OptionsScreen extends StatefulWidget {

  const OptionsScreen({Key? key}) : super(key: key);

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {

  void _showquitDialogue(){
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: ThemeData(
          dialogTheme: DialogTheme(
            elevation: 0,
          ),
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.only(
            top: 56,
            bottom: 56,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Are you sure you don’t want to",
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2d2d2d),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                " find the right fit for your client",
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2d2d2d),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 7,),
              Image.asset("assets/emoji.png"),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 44,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Color(0xffE6E6E6),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          "Yes",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff373737),
                            height: 24/16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 9,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 44,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Color(0xffFF9431),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          "No",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff010100),
                            height: 24/16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  String listingType="";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        _showquitDialogue();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
                onPressed: (){
                  _showquitDialogue();
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
                  // Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  //   return DropDown();
                  // }));
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
      ),
    );
  }
}


