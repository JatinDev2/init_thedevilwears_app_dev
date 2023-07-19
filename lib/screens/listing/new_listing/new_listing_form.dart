import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dropdown.dart';

class NewListingForm extends StatefulWidget {
  String listingType;

  NewListingForm({
   required this.listingType,
});

  @override
  State<NewListingForm> createState() => _NewListingFormState();
}

class _NewListingFormState extends State<NewListingForm> {
  List<Asset> selectedImages = [];
  String dropdownValue = 'Movie Promotions';
  bool isVisible=false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          // Navigator.pushNamed(context, '/listingScreen');
          Navigator.of(context).push(MaterialPageRoute(builder: (_){
            return DropDown();
          }));
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.black,)),
        title: Text(
          "Listing", style: TextStyle(
          color: Color(0xff0F1015),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
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
                      Text(
                        "Listing type",
                        style: const TextStyle(
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
                        "Who do you want to style?*",
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
                        child: DropdownButtonHideUnderline(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              // Set the text style for the dropdown button
                              textTheme: Theme.of(context).textTheme.copyWith(
                                subtitle1: TextStyle(
                                  color: Colors.blue, // Set the desired text color for the dropdown button
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              elevation: 16,
                              style: TextStyle(color: Colors.blue, fontSize: 16),
                              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[800]),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>[
                                'Ad films',
                                'Events & Public appearances',
                                'Movies',
                                'Movie Promotions',
                                'Weddings',
                                'Shoots'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xffb2b2b2),
                                        height: 21 / 14,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
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
                        "By when do you need the products?* ",
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
                      Container(
                        margin: EdgeInsets.all(13.0),
                        height: 102,
                        width: 362,
                        decoration: BoxDecoration(
                          color: Color(0xffF8F7F7),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                            top: 23.0,
                          bottom: 11.0,
                        ),
                                child: Icon((Icons.add),size: 12,)),
                            Text(
                              "The more specific your tags are, better the options you",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff444444),
                              ),
                            ),
                        SizedBox(height: 4,),
                        Text(
                        "shall receive for your lisiting",
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff444444),
                        ),
                        ),
                          ],
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
                      Text(
                        "Describe your requirement in detail*",
                        style: const TextStyle(
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
                        height: 237,
                        width: 364,
                        decoration: BoxDecoration(
                          color: Color(0xffF8F7F7),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextFormField(
                          maxLines: 6,
                          decoration: InputDecoration(
                            hintText: "Start typing here...",
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
                              return 'Please enter the details.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Moodboard",
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff2d2d2d),
                          height: 24 / 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 12,),
                      Container(
                        height: 85,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return GestureDetector(
                                onTap: () {
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
                                                    // Handle camera option
                                                    Navigator.pop(context);
                                                    List<Asset> images = await MultiImagePicker.pickImages(
                                                      maxImages: 5,
                                                      enableCamera: true,
                                                      materialOptions: MaterialOptions(
                                                        actionBarColor: "#FF4081",
                                                        actionBarTitle: "Select Images",
                                                        allViewTitle: "All Photos",
                                                        useDetailsView: false,
                                                        selectCircleStrokeColor: "#FF4081",
                                                      ),
                                                    );
                                                    // Use the selected images as desired
                                                    // Display the selected images in the respective boxes
                                                    setState(() {
                                                      // Update the list of selected images
                                                      selectedImages = images;
                                                    });
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
                                                    List<Asset> images = await MultiImagePicker.pickImages(
                                                      maxImages: 5,
                                                      enableCamera: false,
                                                      materialOptions: MaterialOptions(
                                                        actionBarColor: "#FF4081",
                                                        actionBarTitle: "Select Images",
                                                        allViewTitle: "All Photos",
                                                        useDetailsView: false,
                                                        selectCircleStrokeColor: "#FF4081",
                                                      ),
                                                    );
                                                    // Use the selected images as desired
                                                    // Display the selected images in the respective boxes
                                                    setState(() {
                                                      // Update the list of selected images
                                                      selectedImages = images;
                                                    });
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
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0
                                  ),
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
                            } else {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0
                                ),
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



              ],
            ),
          ),
        ),
      ),
    );
  }
}



// Container(
// child: Column(
// children: [
// Row(
// children: [
// CircleAvatar(
// radius: 20,
// backgroundImage: NetworkImage(
// "https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",
// ),
// ),
// SizedBox(width: 8),
// Expanded(
// child: TextFormField(
// decoration: InputDecoration(
// hintText: "Add your comments...",
// hintStyle: TextStyle(
// color: Color(0xffACACAC),
// fontSize: 14,
// ),
// border: InputBorder.none,
// ),
// ),
// ),
// ],
// ),
// SizedBox(height: 8),
// GestureDetector(
// onTap: () {
// if (_formKey.currentState!.validate()) {
// // All fields are valid, perform submission logic here
// print('Form submitted!');
// }
// },
// child: Container(
// height: 50,
// decoration: BoxDecoration(
// color: Colors.orange,
// borderRadius: BorderRadius.circular(10),
// ),
// width: MediaQuery.of(context).size.width - 8,
// child: Center(
// child: Text(
// "Send your options",
// style: TextStyle(
// color: Colors.white,
// fontSize: 16,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// ),
// ),
// SizedBox(
// height: 16,
// ),
// ],
// ),
// ),

