import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/screens/listing/response_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class PreviewScreen_Second extends StatefulWidget {
  final List selectedItems;

  PreviewScreen_Second({
    required this.selectedItems,
  });

  @override
  State<PreviewScreen_Second> createState() => _PreviewScreen_SecondState();
}

class _PreviewScreen_SecondState extends State<PreviewScreen_Second> {
  final ScrollController myScrollController = ScrollController();
  int currentIndex = 0;
  bool isScrollIconVisible = false;

  @override
  void initState() {
    super.initState();
    myScrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    myScrollController.removeListener(_onScroll);
    myScrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      currentIndex = (myScrollController.offset / myScrollController.position.maxScrollExtent * (widget.selectedItems.length - 1)).round();
      isScrollIconVisible = myScrollController.position.extentBefore > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
          color: Colors.black,
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
      body: GestureDetector(
        onTapDown: (_) {
          setState(() {
            isScrollIconVisible = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            isScrollIconVisible = false;
          });
        },
        child: Container(
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) {
                    _onScroll();
                  }
                  return false;
                },
                child: DraggableScrollbar.semicircle(
                  controller: myScrollController,
                  child: ListView.builder(
                    controller: myScrollController,
                    padding: EdgeInsets.zero,
                    itemCount: widget.selectedItems.length,
                    itemBuilder: (context, index) {
                      return _gridItem(index);
                    },
                  ),
                ),
              ),
              Visibility(
                visible: isScrollIconVisible,
                child: Positioned(
                  top: 24,
                  right: 30,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: 75,
                    child: ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: widget.selectedItems.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == currentIndex;
                        final borderColor = isSelected ? Colors.white : Colors.transparent;
                        final borderWidth = isSelected ? 2.0 : 0.0;

                        return Container(
                          margin: EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor, width: borderWidth),
                          ),
                          child: ClipRRect(
                            child: Image.network(
                              widget.selectedItems[index].imageUrl,
                              height: 60,
                              fit: BoxFit.cover,
                              width: 40,
                            ),
                          ),
                        );
                      },
                    ),
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
        ),
      ),
    );
  }

  Widget _gridItem(int index) {
    var item = widget.selectedItems[index];
    return Container(
      height: 400,
      margin: EdgeInsets.only(
        left: 2,
        right: 2,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            Colors.black,
          ],
        ),
      ),
      child: Container(
        child: Stack(
          children: [
            /// Background Image
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(item.imageUrl),
                  fit: BoxFit.cover,
                  height: 400,
                ),
              ),
            ),
            /// Top Text
            Positioned.fill(
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomLeft,
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
                  child: Text(
                    widget.selectedItems[index].caption ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            if (item is GridItemData)
              Positioned.fill(
                bottom: 0,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 13.w,
                      vertical: 13.h,
                    ),
                    child: Icon(Icons.collections, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
