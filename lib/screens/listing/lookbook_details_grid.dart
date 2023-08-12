import 'dart:math';
import 'package:flutter/material.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/services.dart';
import 'package:lookbook/screens/listing/response_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class LookBookItem {
  String imageUrl;
  bool isSelected;
  String caption;
  bool isTapped;

  LookBookItem({
    required this.isSelected,
    required this.imageUrl,
    this.caption="",
    this.isTapped=false,
  });
}

class LookbookGridScreen extends StatefulWidget {
  String headText;
  String subText;
  List previousSelectedItems;

  LookbookGridScreen({
    required this.headText,
    required this.subText,
    required this.previousSelectedItems,
  });

  @override
  State<LookbookGridScreen> createState() => _LookbookDetailsState();
}

class _LookbookDetailsState extends State<LookbookGridScreen>
    with SingleTickerProviderStateMixin {
  final faker = Faker.instance;

  bool isLoading = true;
  int _selected = 0;
  int currentIndex=-1;

  late List lookBookItems; // List to store LookBookItem objects
  List selectedItems = [];
  TextEditingController captionController = TextEditingController();

  _select(int index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  void initState() {
    super.initState();
    generateLookBookItems(); // Generate LookBookItem objects
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void generateLookBookItems() {
    lookBookItems = List.generate(18, (index) {
      return LookBookItem(
        isSelected: false,
        imageUrl: '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context,widget.previousSelectedItems);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(widget.previousSelectedItems);
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
          ),
          title: Text(
            "${widget.headText} | ${widget.subText}",
            style: TextStyle(
              color: Color(0xff0F1015),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 100 / 150,
                      ),
                      itemCount: isLoading ? 18 : lookBookItems.length,
                      itemBuilder: (context, index) {
                        return isLoading
                            ? _shimmerItem()
                            : _gridItem(lookBookItems[index]);
                      },
                    ),
                  ),
                ),
                widget.previousSelectedItems.isNotEmpty? SizedBox(
                  height: 220,
                ) : Container(),
              ],
            ),
            Positioned(
              bottom: 0,
              child: widget.previousSelectedItems.isEmpty? Container() :  Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.previousSelectedItems.length,
                        itemBuilder: (context, index) {
                          var item=widget.previousSelectedItems[index];
                          if (item.isTapped == true){
                            currentIndex = index;
                          }
                          if(item is GridItemData){
                            return _selectedItemGrid(index);
                          }
                          else{
                            return _selectedItem(index);
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width - 20,
                      decoration: BoxDecoration(
                        color: Color(0xffF7F7F7),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextField(
                        maxLines: 2,
                        controller: captionController,
                        onChanged: (value) {
                          widget.previousSelectedItems[currentIndex].caption = value;
                        },
                        decoration: InputDecoration(
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
                      onTap: (){
                        Navigator.pushNamed(context, '/listingPreviewScreenFirst', arguments: widget.previousSelectedItems );
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
                          child: Text("Preview", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Grid Item
  _gridItem(LookBookItem item) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.vibrate();
        setState(() {
          item.isSelected = !item.isSelected;
          if(item.isSelected){
            widget.previousSelectedItems.add(item);
            selectedItems.add(item);
          }else{
            selectedItems.remove(item);
          }
        });
        // Navigator.pushNamed(context, '/lookbookImagesSliderScreen');
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

  /// Shimmer
  _shimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.2),
      highlightColor: Colors.white,
      child: Container(
        color: Colors.grey,
      ),
    );
  }

  Widget _selectedItem(int index){
    var item = widget.previousSelectedItems[index];
    return GestureDetector(
      onTap: (){
        setState(() {
          for (var selectedItem in widget.previousSelectedItems) {
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
              image: NetworkImage(widget.previousSelectedItems[index].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: (){
                setState((){
                  widget.previousSelectedItems[index].isSelected = false;
                  widget.previousSelectedItems.remove(widget.previousSelectedItems[index]);
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

  Widget _selectedItemGrid(int index){
    var item = widget.previousSelectedItems[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          for (var selectedItem in widget.previousSelectedItems) {
            if (selectedItem != item) {
              selectedItem.isTapped = false;
            }
          }
          item.isTapped = true;
          captionController.text = item.caption;
        });
      },
      child: Container(
        width: 80,
        margin: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          border: Border.all(color: item.isTapped ? Colors.black : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 2,
              child: Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(widget.previousSelectedItems[index].imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10, // Adjusted positioning
              child: Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(widget.previousSelectedItems[index].imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(widget.previousSelectedItems[index].imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    setState((){
                      widget.previousSelectedItems[index].isSelected = false;
                      widget.previousSelectedItems.remove(widget.previousSelectedItems[index]);
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
          ],
        ),
      ),
    );
  }
}

