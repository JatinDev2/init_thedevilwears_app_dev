import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/screens/listing/response_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

import 'PriviewScreen_second.dart';
import 'lookbook_details_grid.dart';

class PreviewScreen_First extends StatefulWidget {
  final List selectedItems;
  
  PreviewScreen_First({
    required this.selectedItems,
});

  @override
  State<PreviewScreen_First> createState() => _PreviewScreen_FirstState();
}

class _PreviewScreen_FirstState extends State<PreviewScreen_First> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close),
              color: Colors.black,
            ),
          ],
        ),
        title: Text(
          "Preview",
          style: TextStyle(
            color: Color(0xff0F1015),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Let the stylist know a description of your entry here....',
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.selectedItems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 100 / 150,
                      ),
                      itemBuilder: (context, index) => _gridItem(index),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/listingConfirmResponseScreen');
              },
              child: Container(
                height: 56,
                width: 182,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text("Submit", style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }

  // Widget _gridItem(int index) {
  //   var item = widget.selectedItems[index];
  //   return GestureDetector(
  //     child: FadeInImage(
  //       placeholder: MemoryImage(kTransparentImage),
  //       image: NetworkImage(item.imageUrl),
  //       fit: BoxFit.cover,
  //     ),
  //   );
  // }

  // decoration: const BoxDecoration(
  // gradient: LinearGradient(
  // begin: Alignment.center,
  // end: Alignment.bottomCenter,
  // colors: [
  // Colors.transparent,
  // Colors.black,
  // ],
  // ),
  // ),

 Widget _gridItem(int index) {
   var item = widget.selectedItems[index];
   return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/listingPreviewScreenSecond', arguments:widget.selectedItems);
      },
      child: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
            ),
          ),

          if(item is GridItemData)
            Positioned.fill(
              bottom: 0,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 8, right: 8),
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset("assets/multiple.svg"),
                ),
              ),
            ),

          Positioned.fill(child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black,
                ],
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 13.w,
                  vertical: 13.h,
                ),

                child: Text(
                  widget.selectedItems[index].caption ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                  maxLines: 2,             // Set the maximum number of lines to 2
                  overflow: TextOverflow.ellipsis,  // Display remaining text with dots
                ),
              ),
            ),
          ))

        ],
      ),
    );
  }


}

