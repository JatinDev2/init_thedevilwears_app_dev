import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lookbook/screens/listing/new_listing/List_Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../../common_widgets.dart';
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
  final CollectionReference listCollection = FirebaseFirestore.instance.collection('listings');

  Future<void> uploadImagesToStorage(String userId, List imageFileList) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;

      // Create a reference to the root folder for listings
      Reference listingsRoot = storage.ref().child('listings');

      // Create a reference to the user's folder using their userId
      Reference userFolder = listingsRoot.child(userId);

      // Upload each image to the user's folder
      for (int i = 0; i < imageFileList.length; i++) {
        XFile imageFile = imageFileList[i];
        String imageName = 'image_$i.jpg'; // You can use a custom name here

        Reference imageRef = userFolder.child(imageName);

        // Convert XFile to File if needed
        File file = File(imageFile.path);

        // Check if the file exists before uploading
        if (await file.exists()) {
          await imageRef.putFile(file);

          // Get the download URL for the uploaded image (if needed)
          String imageUrl = await imageRef.getDownloadURL();

          // You can store the imageUrl in your Firestore database if necessary
        } else {
          print('File does not exist: ${file.path}');
        }
      }

      print('Images uploaded successfully');
    } catch (e) {
      print('Error uploading images: $e');
    }
  }

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
      body: ListView(
        children: [
          if(widget.newModel.tags!.isNotEmpty)
          Container(
            margin: EdgeInsets.all(13.0),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: widget.newModel.tags!.map((option) {
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
                Text("${widget.newModel.createdBy}", style: TextStyle(
                  color: Color(0xff0F1015),
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),),
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
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 60/ 85,
              ),
            itemCount: widget.newModel.images!.length,
            itemBuilder: (context, index) {
              if (index+1 < widget.newModel.images!.length){
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
                        child: Image.file(File(widget.newModel.images![index+1].path), fit: BoxFit.cover,)

                    ),
                  ),
                );
              }
            },
          ),
          Container(
            child: Column(
              children: [
                SizedBox(height: 8,),
                GestureDetector(
                  onTap: () async{
                    setState(() {
                      isLoading=true;
                    });
                    try {
                      await listCollection.add({
                        'userId': widget.newModel.userId,
                        'listingType': widget.newModel.listingType,
                        'toStyleName': widget.newModel.toStyleName,
                        'toStyleInsta': widget.newModel.instaHandle,
                        'eventCategory': widget.newModel.eventCategory,
                        'eventDate':widget.newModel.eventDate,
                        'productDate': widget.newModel.productDate,
                        'location': widget.newModel.location,
                        'preferences': widget.newModel.selectedTags,
                        'requirements': widget.newModel.requirement,
                        'timeStamp': DateTime.now().toString(),
                        'createdBy': widget.newModel.createdBy,
                      }).then((value) {
                        uploadImagesToStorage(value.id,widget.newModel.images!).then((value) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_){
                            return ConfirmListing_Screen();
                          }));
                          setState(() {
                            isLoading=false;
                          });
                        });
                      });
                      print('User added to Firestore');
                    } catch (e) {
                      print('Error adding user to Firestore: $e');
                    }
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
                        child: isLoading? CircularProgressIndicator(
                          color: Colors.white,
                        ) : Text("Submit", style: TextStyle(
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
    );
  }

}


