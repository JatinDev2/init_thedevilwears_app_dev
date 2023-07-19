import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:lookbook/screens/listing/new_listing/List_Model.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'ConfirmListing.dart';

class PreviewScreen extends StatefulWidget {
  ListModel newModel;

  PreviewScreen({
    required this.newModel,
});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {

  bool isLoading=true;
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          // Navigator.pushNamed(context, '/listingScreen');
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.black,)),
        title: Text(
          "Priview your listing", style: TextStyle(
          color: Color(0xff0F1015),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.all(13.0),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: widget.newModel.tags.map((option) {
                          return OptionChipDisplay(
                            title: option,
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(13.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage("https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                        child: Text("Tanya Ghavri", style: TextStyle(
                          color: Color(0xff0F1015),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),)
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Listing Type", style: TextStyle(
                      color: Color(0xff141414),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 6,),
                    Text(widget.newModel.listingType, style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontSize: 13,
                    ),),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Client Name", style: TextStyle(
                      color: Color(0xff141414),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 6,),
                    Text(widget.newModel.toStyleName, style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontSize: 13,
                    ),),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Instagram Handle", style: TextStyle(
                      color: Color(0xff141414),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 6,),
                    Text(widget.newModel.instaHandle, style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontSize: 13,
                    ),),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Event Category", style: TextStyle(
                      color: Color(0xff141414),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 6,),
                    Text(widget.newModel.eventCategory, style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontSize: 13,
                    ),),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Event Date", style: TextStyle(
                      color: Color(0xff141414),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 6,),
                    Text(widget.newModel.eventDate, style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontSize: 13,
                    ),),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product required by", style: TextStyle(
                      color: Color(0xff141414),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 6,),
                    Text(widget.newModel.productDate, style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontSize: 13,
                    ),),
                  ],
                ),
              ),


              Container(
                margin: EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Location at which the products are needed", style: TextStyle(
                      color: Color(0xff141414),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 6,),
                    Text(widget.newModel.location, style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontSize: 13,
                    ),),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Requirement", style: TextStyle(
                      color: Color(0xff141414),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 6,),
                    Text(widget.newModel.requirement, style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontSize: 13,
                    ),),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.all(13),
                child: Text("Moodboard", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              Container(
                height: 400,
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 60/ 85,
                    ),
                  itemCount: widget.newModel.images.length,
                  itemBuilder: (context, index) {
                    if (index+1 < widget.newModel.images.length){
                      // Display the selected image
                      return Container(
                        width: 88,
                        height: 119,
                        color: Color(0xffF4F4F4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                              child: Image.file(File(widget.newModel.images[index+1].path), fit: BoxFit.cover,)

                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(height: 8,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (_){
                          return ConfirmListing_Screen();
                        }));
                        // Navigator.pushNamed(context, '/listingResponseScreen');
                      },
                      child: Center(
                        child: Container(
                          height: 50,

                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius:BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width -8,
                          child: Center(
                            child: Text("Submit", style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


class OptionChipDisplay extends StatelessWidget {
  final String title;

  OptionChipDisplay({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 4.0,
          left: 4.0,
          right: 4.0,
          bottom: 4.0
      ),
      padding:EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color:Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
