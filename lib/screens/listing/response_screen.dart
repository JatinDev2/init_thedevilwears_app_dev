import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

import 'PreviewScreen_first.dart';
import 'lookbook_details_grid.dart';

class ResponseScreen extends StatefulWidget {
  const ResponseScreen({Key? key}) : super(key: key);

  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  final faker = Faker.instance;
  bool isLoading = true;
  List gridItems = [];
  List selectedItems = [];
  TextEditingController captionController = TextEditingController();
  int currentIndex = -1;

  @override
  void initState() {
    super.initState();
    gridItems = GridItemData.generateItems();
    Future.delayed(Duration.zero, () {
      _showEntryDialogue();
    });
  }

  void _showEntryDialogue(){
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
            top: 40,
            bottom: 40,
            left: 15,
            right: 15
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Your application is private.",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2d2d2d),
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                "Only the owner of the listing can view it.",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2d2d2d),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 44,
                      width: 198,
                      decoration: BoxDecoration(
                        color: Color(0xffFF9431),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Center(
                        child: Text(
                          "Great, let’s begin",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 24/16,
                          ),
                          textAlign: TextAlign.left,
                        )
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'listingDetailsScreen');
              },
              icon: Icon(Icons.close),
              color: Colors.black,
            ),
          ],
        ),
        title: Text(
          "Application to Shabana Khan",
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
                  Container(
                    margin: EdgeInsets.all(12.0),
                    child: Text(
                      "Select products from lookbook",
                      style: TextStyle(
                        color: Color(0xff262626),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: gridItems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 100 / 150,
                      ),
                      itemBuilder: (context, index) => _gridItem(index),
                    ),
                  ),
                  selectedItems.isNotEmpty? SizedBox(
                    height: 220,
                  ) : Container(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: selectedItems.isEmpty
                ? Container()
                : Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    height: 68,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedItems.length,
                      itemBuilder: (context, index) {
                        var item = selectedItems[index];
                        if (item.isTapped == true){
                          currentIndex = index;
                        }
                        if (item is GridItemData) {
                          return _selectedItem(index);
                        } else {
                          return _selectedItemLookBook(index);
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5.0),
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextField(
                      maxLines: 2,
                      controller: captionController,
                      onChanged: (value) {
                        selectedItems[currentIndex].caption = value;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        hintText: "Add a caption or skip it...",
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/listingPreviewScreenFirst', arguments:selectedItems );
                    },
                    child: Container(
                      height: 56,
                      width: 182,
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(
                        child: Text(
                          "Preview",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectedItem(int index) {
    var item = selectedItems[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          for (var selectedItem in selectedItems) {
            if (selectedItem != item) {
              selectedItem.isTapped = false;
            }
          }
          item.isTapped = true;
          captionController.text = item.caption;
        });
      },
      child: Container(
        width: 74,
        margin: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          border: Border.all(color: item.isTapped ? Colors.black : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0, // Adjusted positioning
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child:Image.network(selectedItems[index].imageUrl, fit: BoxFit.cover, height: 58,) ,
                ),
              ),
            ),
            Positioned(
              right: 5, // Adjusted positioning
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child:Image.network(selectedItems[index].imageUrl, fit: BoxFit.cover, height: 58,) ,
                ),
              ),
            ),
            Positioned(
              right: 10, // Adjusted positioning
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child:Image.network(selectedItems[index].imageUrl, fit: BoxFit.cover, height: 58,) ,
                ),
              ),
            ),

            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  setState((){
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
                                top: 40,
                                bottom: 40,
                                left: 15,
                                right: 15
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Are you sure you want to delete this?",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff2d2d2d),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20,),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pop();
                                  },
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).pop();
                                          setState(() {
                                            selectedItems[index].isSelected = false;
                                            selectedItems.remove(selectedItems[index]);
                                            captionController.clear();
                                          });
                                        },
                                        child: Container(
                                          height: 44,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: Color(0xffE6E6E6),
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
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
                                      const SizedBox(width: 9,),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          height: 44,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFF9431),
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "No",
                                              style: TextStyle(
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
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
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectedItemLookBook(int index) {
    var item = selectedItems[index];
    return GestureDetector(
      onTap: (){
        setState(() {
          for (var selectedItem in selectedItems) {
            if (selectedItem != item) {
              selectedItem.isTapped = false;
            }
          }
          item.isTapped = true;
          captionController.text = item.caption;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: item.isTapped? Colors.black : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        width: 80,
        margin: EdgeInsets.all(2.0),
        child: Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: NetworkImage(selectedItems[index].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: (){
                setState((){
                  selectedItems[index].isSelected = false;
                  selectedItems.remove(selectedItems[index]);
                  captionController.clear();
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
        ),
      ),
    );
  }

  Widget _gridItem(int index) {
    GridItemData item = gridItems[index];
    return GestureDetector(
      onLongPress: () {
        setState(() {
          item.isSelected = !item.isSelected;
          if (item.isSelected) {
            selectedItems.add(item);
          } else {
            selectedItems.remove(item);
          }
        });
        HapticFeedback.vibrate();
      },
      onTap: () {
        if (item.isSelected) {
          setState(() {
            item.isSelected = false;
            selectedItems.remove(item);
          });
        } else{
          Navigator.pushNamed(context, '/listinglookbookdetails', arguments: {
            'headText':item.name,
            'subText' : item.companyName,
            'previousSelectedItems' : selectedItems,
          }).then((value) {
            setState((){
              selectedItems = value as List;
              captionController.clear();
            });
          });
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: item.isSelected ? 0.6 : 1.0,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(item.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 13.w,
                vertical: 13.h,
              ),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.companyName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(!item.isSelected)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(top: 8, right: 8),
                width: 24,
                height: 24,
                child: SvgPicture.asset("assets/multiple.svg"),
              ),
            ),
          if (item.isSelected)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(top: 8, right: 8),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class GridItemData {
  final String imageUrl;
  final String name;
  final String companyName;
  bool isSelected;
  bool isTapped;
  String caption;

  GridItemData({
    required this.imageUrl,
    required this.name,
    required this.companyName,
    this.isSelected = false,
    this.isTapped = false,
    this.caption = '',
  });

  static List<GridItemData> generateItems() {
    final faker = Faker.instance;
    List<GridItemData> items = [];
    for (int i = 0; i < 14; i++){
      items.add(GridItemData(
        imageUrl: '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}',
        name: faker.name.fullName(),
        companyName: faker.company.companyName(),
        isSelected: false,
        isTapped: false,
        caption: '',
      ));
    }
    return items;
  }
}
