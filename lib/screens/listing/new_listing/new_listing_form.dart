import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/screens/listing/new_listing/List_Model.dart';
import 'package:lookbook/screens/listing/new_listing/preview_listing.dart';
import 'package:lookbook/screens/listing/new_listing/tags_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ConfirmListing.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dropdown.dart';
import 'package:image_picker/image_picker.dart';

class NewListingForm extends StatefulWidget {
  String listingType;

  NewListingForm({
   required this.listingType,
});

  @override
  State<NewListingForm> createState() => _NewListingFormState();
}

class _NewListingFormState extends State<NewListingForm> {

  ListModel? newModel;
  // List<Asset> selectedImages = [Asset("_identifier", "_name", 1, 1)];
  List<String> selectedOption=[];
  Map<String,List<String>>_selectedOptions={};
  String dropdownValue = 'Movie Promotions';
  bool isVisible=false;
  bool isLoading=false;
  double progress = 0.0;


  final _formKey = GlobalKey<FormState>();
  TextEditingController toStyleNamecontroller=TextEditingController();
  TextEditingController instaHandelConnroller=TextEditingController();
  TextEditingController eventDateConnroller=TextEditingController();
  TextEditingController productDateConnroller=TextEditingController();
  TextEditingController locationConnroller=TextEditingController();
  TextEditingController detailConnroller=TextEditingController();
  final ImagePicker imagePicker=ImagePicker();
  List<XFile>imageFileList=[XFile("")];
  final CollectionReference listCollection = FirebaseFirestore.instance.collection('listings');

  Future<void> uploadImagesToStorage(String userId, List<XFile> imageFileList) async {
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

          // Calculate the progress and update the UI
          // double progress = (i + 1) / imageFileList.length;
          // print('Progress: ${(progress * 100).toStringAsFixed(2)}%');
          progress = (i + 1) / imageFileList.length;
          print('Progress: ${(progress * 100).toStringAsFixed(2)}%');

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

  double calculateProgress(List<XFile> imageFileList) {
    int totalImages = imageFileList.length;
    int uploadedImages = 0;
    for (var imageFile in imageFileList) {
      File file = File(imageFile.path);
      if (file.existsSync()) {
        uploadedImages++;
      }
    }
    return uploadedImages / totalImages;
  }


  Future<void> _selectDate(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != eventDateConnroller.text) {
      setState((){
        eventDateConnroller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectProductDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != productDateConnroller.text) {
      setState(() {
        productDateConnroller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _showDialogue(){
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(() {
                          imageFileList.add(image);
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 57,
                          width: 57,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/Camera.svg',
                              semanticsLabel: 'My SVG Image',
                              height: 35,
                              width: 35,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Camera",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff222222),
                            height: 19 / 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 65),
                  GestureDetector(
                    onTap: () async {
                      // Handle gallery option
                      Navigator.pop(context);
                      final List<XFile>? selectedImagesFile= await imagePicker.pickMultiImage();
                      if(selectedImagesFile!.isNotEmpty){
                        setState(() {
                          imageFileList.addAll(selectedImagesFile);
                        });
                      }
                      // List<Asset> images = await MultiImagePicker.pickImages(
                      //   maxImages: 100 - selectedImages.length,
                      //   enableCamera: false,
                      // );
                      // Use the selected images as desired
                      // Display the selected images in the respective boxes
                      // setState(() {
                      //   // Update the list of selected images
                      //   selectedImages.addAll(images);
                      // });
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 57,
                          width: 57,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/gallery.svg',
                              semanticsLabel: 'My SVG Image',
                              height: 35,
                              width: 35,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff222222),
                            height: 19 / 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
              SizedBox(height: 15,),
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

  List<String> items=[
    'Ad films',
    'Events & Public appearances',
    'Movies',
    'Movie Promotions',
    'Weddings',
    'Shoots'
  ];

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{
        _showquitDialogue();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(onPressed: (){
            Navigator.pushNamed(context, '/listingScreen');
            Navigator.of(context).pop();
          }, icon: IconButton(
            icon:Icon(Icons.arrow_back_ios_new, color: Colors.black,),
      onPressed: (){
        _showquitDialogue();
      },
      ),),
          title:const Text(
            "Create a new listing",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff0f1015),
              height: 20/16,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        const Text(
                          "Listing type",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2d2d2d),
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "${widget.listingType}",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffb2b2b2),
                            height: 21 / 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 2,
                    color: Color(0xffE7E7E7),
                  ),
                  Container(
                    margin: EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Who do you want to style?*",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2d2d2d),
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        TextFormField(
                          controller: toStyleNamecontroller,
                          decoration: InputDecoration(
                            hintText: "Eg: Vicky Kaushal",
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffb2b2b2),
                              height: 21 / 14,
                            ),
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Color(0xffE7E7E7),
                  ),
                  Container(
                    margin: EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Instagram handle of who you are styling",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2d2d2d),
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        TextFormField(
                          controller: instaHandelConnroller,
                          decoration: InputDecoration(
                            hintText: "https://www.instagram.com/vickykaushal",
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffb2b2b2),
                              height: 21 / 14,
                            ),
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an Instagram handle.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Color(0xffE7E7E7),
                  ),
                  Container(
                    margin: EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Event Category*",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2d2d2d),
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child:  DropDown(selectedValue: dropdownValue, items:items ,)
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Color(0xffE7E7E7),
                  ),
                  Container(
                    margin: EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Event Date*",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2d2d2d),
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: eventDateConnroller,
                              decoration: InputDecoration(
                                hintText: "DD/MM/YYYY",
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffb2b2b2),
                                  height: 21 / 14,
                                ),
                                border: InputBorder.none,
                              ),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a date.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  Divider(
                    height: 2,
                    color: Color(0xffE7E7E7),
                  ),

                  Container(
                    margin: EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "By when do you need the products?*",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2d2d2d),
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        GestureDetector(
                          onTap: () => _selectProductDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: productDateConnroller,
                              decoration: InputDecoration(
                                hintText: "DD/MM/YYYY",
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffb2b2b2),
                                  height: 21 / 14,
                                ),
                                border: InputBorder.none,
                              ),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a date.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Color(0xffE7E7E7),
                  ),

                  Container(
                    margin: EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Which location do you need the products at?*",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2d2d2d),
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        TextFormField(
                          controller: locationConnroller,
                          decoration: InputDecoration(
                            hintText: "Eg: Mumbai",
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffb2b2b2),
                              height: 21 / 14,
                            ),
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a location.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Color(0xffE7E7E7),
                  ),
                  Container(
                    margin: EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What are you looking for?*",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2d2d2d),
                            height: 24/16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_){
                              return TagScreen(
                                listSelectedOptions: selectedOption,
                                mapSelectedOptions: _selectedOptions,
                              );
                            })).then((value){
                              setState((){
                                List<String>tempList=value["selectedOptionsList"];
                                if(selectedOption.length <=tempList.length){
                                  if(selectedOption.isNotEmpty){
                                    for(int i=0; i<tempList.length; i++){
                                      if(!selectedOption.contains(tempList[i])){
                                        selectedOption.add(tempList[i]);
                                      }
                                    }
                                  }
                                  else{
                                    selectedOption=value["selectedOptionsList"];
                                  }
                                }
                                else{
                                  selectedOption=value["selectedOptionsList"];
                                }
                                if(_selectedOptions.isNotEmpty){
                                  Map<String,List<String>> temp=value["selectedOptionsMap"];
                                    temp.forEach((key, value){
                                      if(_selectedOptions.containsKey(key)){
                                        for(int i=0; i<value.length;i++){
                                          if(!_selectedOptions[key]!.contains(value[i])){
                                            _selectedOptions[key]!.add(value[i]);
                                          }
                                        }
                                      }
                                      else{
                                        _selectedOptions[key]=value;
                                      }
                                    });
                                }
                                else{
                                  _selectedOptions=value["selectedOptionsMap"];
                                }
                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(13.0),
                            height: 102,
                            width: 362,
                            decoration: BoxDecoration(
                              color: const Color(0xffF8F7F7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(
                                top: 23.0,
                              bottom: 11.0,
                            ),
                                    child: const Icon((Icons.add),size: 12,)),
                                const Text(
                                  "The more specific your tags are, better the options you",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff444444),
                                  ),
                                ),
                            const SizedBox(height: 4,),
                            const Text(
                            "shall receive for your lisiting",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff444444),
                            ),
                            ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Describe your requirement in detail*",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2d2d2d),
                            height: 24/16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          margin: EdgeInsets.all(13.0),
                          padding: EdgeInsets.all(5.0),
                          // height: 237,
                          width: 364,
                          decoration: BoxDecoration(
                            color: Color(0xffF8F7F7),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: TextFormField(
                            controller: detailConnroller,
                            maxLines: 6,
                            decoration: const InputDecoration(
                              hintText: "Start typing here...",
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffb2b2b2),
                                height: 21 / 14,
                              ),
                              border: InputBorder.none,
                            ),
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the details.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(selectedOption.isNotEmpty)
                    Container(
                      margin: EdgeInsets.all(13.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Selected Tags",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff2d2d2d),
                              height: 24/16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Wrap(
                            spacing: 5.0,
                            runSpacing: 5.0,
                            children: selectedOption.map((option) => buildOption(option)).toList(),
                          ),
                        ],
                      ),
                    ),

                  Container(
                    margin: const EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Moodboard",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2d2d2d),
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 12,),
                    Container(
                      height: imageFileList.length < 4? 88: 180,
                      child: GridView.builder(
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: imageFileList.length < 4 ? 4 : imageFileList.length,
                        itemBuilder: (context, index) {
                          if(index==0){
                            return GestureDetector(
                              onTap: () {
                                // Handle add option
                              _showDialogue();
                              },
                              child: Container(
                                width: 82,
                                height: 85,
                                color: Color(0xffF4F4F4),
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                              ),
                            );
                          }
                          if (index < imageFileList.length){
                            // Display the selected image
                            return Stack(
                              children: [
                                Container(
                                  width: 82,
                                  height: 85,
                                  color: Color(0xffF4F4F4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Image.file(File(imageFileList[index].path), fit: BoxFit.cover,)
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState((){
                                        imageFileList.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 4, right: 6),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          else{
                            return Container(
                              width: 82,
                              height: 85,
                              color: Color(0xffF4F4F4),
                            );
                          }
                        },
                      ),
                    ),
                    ],
                    ),
                  ),
              Container(
                margin: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: isLoading? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                  children: [
                    if(!isLoading)
                    GestureDetector(
                      onTap: () async{
                        final prefs = await SharedPreferences.getInstance();
                        final userId = prefs.getString('userId');
                        final firstName = prefs.getString('firstName');
                        final lastName = prefs.getString('lastName');

                        if(_formKey.currentState!.validate()){
                          newModel=ListModel(
                            images: imageFileList,
                            listingType: widget.listingType,
                            location: locationConnroller.text,
                            eventCategory: dropdownValue,
                            eventDate: eventDateConnroller.text,
                            instaHandle: instaHandelConnroller.text,
                            productDate: productDateConnroller.text,
                            requirement: detailConnroller.text,
                            selectedTags: _selectedOptions,
                            toStyleName: toStyleNamecontroller.text,
                            createdBy: "${firstName} ${lastName}",
                            userId: userId,
                          );
                          if (newModel!.selectedTags != null) {
                            newModel!.tags = newModel!.selectedTags!.values.expand((tags) => tags).toList();
                          }
                          Navigator.of(context).push(MaterialPageRoute(builder: (_){
                            return PreviewScreen(
                              newModel: newModel!,
                            );
                          }));
                        }
                        else{
                          FirebaseMessaging.instance.getInitialMessage().then(
                                (message) {
                              print("FirebaseMessaging.instance.getInitialMessage");
                              if (message != null) {
                                print("New Notification");
                                // if (message.data['_id'] != null) {
                                //   Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //       builder: (context) => DemoScreen(
                                //         id: message.data['_id'],
                                //       ),
                                //     ),
                                //   );
                                // }
                              }
                            },
                          );

                          FirebaseMessaging.onMessage.listen(
                                (message) {
                              print("FirebaseMessaging.onMessage.listen");
                              if (message.notification != null) {
                                print(message.notification!.title);
                                print(message.notification!.body);
                                print("message.data11 ${message.data}");
                                // LocalNotificationService.display(message);

                              }
                            },
                          );

                          FirebaseMessaging.onMessageOpenedApp.listen(
                                (message) {
                              print("FirebaseMessaging.onMessageOpenedApp.listen");
                              if (message.notification != null) {
                                print(message.notification!.title);
                                print(message.notification!.body);
                                print("message.data22 ${message.data['_id']}");
                              }
                            },
                          );
                          return;
                        }
                      },
                      child: Container(
                        height: 56,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Color(0xffE6E6E6),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child:  Text(
                            "Preview",
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
                    if(!isLoading)
                    GestureDetector(
                      onTap: () async{
                       //  final provider= Provider.of<GoogleSignInProvider>(context, listen: false);
                       // final userId= provider.user.id;
                        setState(() {
                          isLoading=true;
                        });
                        final prefs = await SharedPreferences.getInstance();
                        final userId = prefs.getString('userId');
                        final firstName = prefs.getString('firstName');
                        final lastName = prefs.getString('lastName');

                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                        try {
                        await listCollection.add({
                          'userId': userId,
                        'listingType': widget.listingType,
                        'toStyleName': toStyleNamecontroller.text,
                        'toStyleInsta': instaHandelConnroller.text,
                        'eventCategory': dropdownValue,
                        'eventDate':eventDateConnroller.text,
                        'productDate': productDateConnroller.text,
                         'location': locationConnroller.text,
                          'preferences': _selectedOptions,
                          'requirements': detailConnroller.text,
                          'timeStamp': DateTime.now().toString(),
                          'createdBy': "${firstName} ${lastName}",
                        }).then((value) {
                          uploadImagesToStorage(value.id,imageFileList).then((value) {
                            setState((){
                              isLoading=false;
                            });
                            Navigator.of(context).push(MaterialPageRoute(builder: (_){
                              return ConfirmListing_Screen();
                            }));
                          });

                        });
                        print('User added to Firestore');
                        } catch (e) {
                        print('Error adding user to Firestore: $e');
                        }
                        }
                        else{
                          return;
                        }
                      },
                      child: Container(
                        height: 56,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child:isLoading?
                          const CircularProgressIndicator(
                            color: Colors.white,
                          ) : const Text(
                            "Submit",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff010100),
                              height: 24/16,
                            ),
                            textAlign: TextAlign.left,
                          )
                        ),
                      ),
                    ),
                    if(isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildOption(String option) {
    // final backgroundColor = isSelected ? Color(0xffFF9431) : Color(0xffF7F7F7);
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color:  Color(0xffFF9431),
          borderRadius: BorderRadius.circular(14.0),
        ),
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              option,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white ,
                height: 18/12,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

}

