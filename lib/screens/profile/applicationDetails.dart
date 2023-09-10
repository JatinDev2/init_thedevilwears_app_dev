import 'dart:math';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:faker_dart/faker_dart.dart';

import '../listing/response_screen.dart';
import 'entryPreviewScreen.dart';

class applicationDetails extends StatefulWidget {
  const applicationDetails({super.key});

  @override
  State<applicationDetails> createState() => _applicationDetailsState();
}

class _applicationDetailsState extends State<applicationDetails> {
  final faker = Faker.instance;
  bool isLoading=false;
  final ScrollController myScrollController = ScrollController();
  int currentIndex=0;
  List<GridItemData> items = [];

  List<GridItemData> generateDummyData() {
    final faker = Faker.instance;
    for (int i = 0; i < 14; i++){
      items.add(GridItemData(
        imageUrl: '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}',
        name: faker.name.fullName(),
        companyName: faker.company.companyName(),
        isSelected: false,
        isTapped: false,
        caption: "The items are available in 5 different sizes. Please contact us to know more about the product. You can call us between 2pm-5pm for any more querries",
      ));
    }
    print(items);
    setState(() {});
    return items;
  }

  @override
  void initState() {
    // TODO: implement initState
    generateDummyData();
    Future.delayed(const Duration(seconds: 1), () {
      setState((){
        isLoading = false;
      });
    });
    myScrollController.addListener(_onScroll);
    super.initState();
  }

  void dispose() {
    myScrollController.removeListener(_onScroll);
    myScrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState((){
      currentIndex = (myScrollController.offset / myScrollController.position.maxScrollExtent * (12)).round();
      // isScrollIconVisible = myScrollController.position.extentBefore > 0;
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
            "Applications for your listing",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff0f1015),
              height: 20/16,
            ),
          )
      ),
     body: Stack(
       children: [
         SingleChildScrollView(
           child: Container(
             height: MediaQuery.of(context).size.height,
             width: MediaQuery.of(context).size.width,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Container(
                   margin: EdgeInsets.all(16.0),
                   child: Row(
                     // mainAxisAlignment: MainAxisAlignment.start,
                     // crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       const CircleAvatar(
                         radius: 20,
                         backgroundImage: NetworkImage("https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",),
                       ),
                       const SizedBox(width: 6,),
                       Column(
                         children: [
                           Text(
                             "Shaleen Nair",
                             style:  TextStyle(
                               fontFamily: "Poppins",
                               fontSize: 18,
                               fontWeight: FontWeight.w700,
                               color: Color(0xff0f1015),
                             ),
                           ),
                           SizedBox(height: 1,),
                           Text(
                             "37 mins ago ",
                             style: const TextStyle(
                               fontFamily: "Poppins",
                               fontSize: 12,
                               fontWeight: FontWeight.w400,
                               color: Color(0xff8b8b8b),
                             ),
                             textAlign: TextAlign.left,
                           ),
                         ],
                       ),
                       Spacer(),
                       Text(
                         "Call now ",
                         style: TextStyle(
                           fontFamily: "Poppins",
                           fontSize: 14,
                           fontWeight: FontWeight.w500,
                           color: Theme.of(context).colorScheme.primary,
                           height: 20/14,
                         ),
                         textAlign: TextAlign.left,
                       ),
                       SizedBox(width: 18,),
                       SvgPicture.asset("assets/callOrange.svg"),
                     ],
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.only(
                     top: 16,
                     left: 16,
                     right: 16,
                     bottom: 6,
                   ),
                   child: Text(
                     "Description",
                     style: const TextStyle(
                       fontFamily: "Poppins",
                       fontSize: 16,
                       fontWeight: FontWeight.w700,
                       color: Color(0xff1e1e1e),
                       height: 24/16,
                     ),
                     textAlign: TextAlign.left,
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.only(
                     left: 16,
                     right: 16
                   ),
                   child: Text(
                     "A description of your entry will be displayed below. For alia bhatt for her new movie promotions. A mustard yellow traditional outfit is required for alia bhatt for her new movie promotions. The fabric needs to have the following details of the clothes. It is supposed to be yellow in color. The theme of the even is more inclined towards formal wear. ",
                     style: const TextStyle(
                       fontFamily: "Poppins",
                       fontSize: 12,
                       fontWeight: FontWeight.w400,
                       color: Color(0xff313131),
                     ),
                     textAlign: TextAlign.left,
                   ),
                 ),

                 Container(
                   margin: EdgeInsets.only(
                     left: 16,
                     right: 16,
                     top: 16,
                   ),
                   child: Row(
                     children: [
                       Text(
                         "Entry",
                         style: const TextStyle(
                           fontFamily: "Poppins",
                           fontSize: 16,
                           fontWeight: FontWeight.w700,
                           color: Color(0xff1e1e1e),
                           height: 24/16,
                         ),
                         textAlign: TextAlign.left,
                       ),
                       Spacer(),
                       Text(
                         "44 images",
                         style: const TextStyle(
                           fontFamily: "Poppins",
                           fontSize: 12,
                           fontWeight: FontWeight.w400,
                           color: Color(0xff8b8b8b),
                           height: 18/12,
                         ),
                         textAlign: TextAlign.left,
                       ),
                     ],
                   )
                 ),
                 SizedBox(height: 14,),
                 Expanded(
                   child: Container(
                     margin: EdgeInsets.only(
                       left: 4.0,
                       right: 4.0,
                       top: 4.0,
                     ),
                     child: NotificationListener<ScrollNotification>(
                       onNotification: (notification) {
                         if (notification is ScrollEndNotification) {
                           _onScroll();
                         }
                         return false;
                       },
                       child: DraggableScrollbar.semicircle(
                         controller: myScrollController,
                         child: GridView.builder(
                           itemCount: 12,
                             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                               crossAxisCount: 2,
                               mainAxisSpacing: 4,
                               crossAxisSpacing: 4,
                               childAspectRatio: 100 / 150,
                             ),
                             controller:myScrollController,
                             itemBuilder: (context, index) => isLoading
                                 ? _shimmerItem()
                                 : _gridItem()
                         ),
                       ),
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ),
         Align(
           alignment: Alignment.bottomCenter,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               Container(
                 height: 56,
                 width: 183,
                 decoration: BoxDecoration(
                   color: Theme.of(context).colorScheme.primary,
                   borderRadius: BorderRadius.circular(10.0),
                 ),
                 child: Center(
                   child: Text(
                     "Contact",
                     style: const TextStyle(
                       fontFamily: "Poppins",
                       fontSize: 16,
                       fontWeight: FontWeight.w700,
                       color: Colors.white,
                       height: 24/16,
                     ),
                     textAlign: TextAlign.left,
                   ),
                 ),
               ),
               SizedBox(height: 10,),
             ],
           ),
         ),
       ],
     ),
    );
  }

  _gridItem() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_){
          return entryScreenPreview(
            selectedItems: items,
          );
        }));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: [
            /// Background Image
            Positioned.fill(
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                  '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}',
                ),
                fit: BoxFit.cover,
              ),
            ),

            /// Top Text
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
                      faker.name.fullName(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      faker.company.companyName(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12.sp,
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

  _shimmerItem() {
    return Stack(
      children: [
        Positioned.fill(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.5),
            highlightColor: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 13.w,
                vertical: 13.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    width: 120.w,
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    width: 80.w,
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

}
