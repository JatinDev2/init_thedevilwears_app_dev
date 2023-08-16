import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transparent_image/transparent_image.dart';

import '../listing/response_screen.dart';

class entryScreenPreview extends StatefulWidget {
  // const entryScreenPreview({super.key});
  List selectedItems;

  entryScreenPreview({
    required this.selectedItems,
});

  @override
  State<entryScreenPreview> createState() => _entryScreenPreviewState();
}

class _entryScreenPreviewState extends State<entryScreenPreview> {
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
    setState((){
      currentIndex = (myScrollController.offset / myScrollController.position.maxScrollExtent * (widget.selectedItems.length - 1)).round();
      isScrollIconVisible = myScrollController.position.extentBefore > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black,)),
          title: const Text(
            "Entry",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff0f1015),
              height: 20/16,
            ),
          )
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
      margin: const EdgeInsets.only(
        left: 2,
        right: 2,
        bottom: 5,
      ),

      child: Stack(
        children: [
          /// Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
              height: 400,
            ),
          ),

          Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: const LinearGradient(
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
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )),
          if (item is GridItemData)
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
        ],
      ),
    );
  }
}
