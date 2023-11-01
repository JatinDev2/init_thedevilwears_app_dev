import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:faker_dart/faker_dart.dart';

import 'PriviewScreen_second.dart';
import 'Priview_listing_gallery.dart';
import 'new_listing/List_Model.dart';


class Details_Screen extends StatefulWidget {
  ListModel listing;

  Details_Screen({
   required this.listing,
});
  // const Details_Screen({Key? key}) : super(key: key);

  @override
  State<Details_Screen> createState() => _Details_ScreenState();
}

class _Details_ScreenState extends State<Details_Screen> {

  // final faker = Faker.instance;
  bool isLoading=true;
  @override
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
        }, icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black,)),
        title: const Text(
          "Listing",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xff0f1015),
            height: 20/16,
          ),
          textAlign: TextAlign.left,
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(IconlyLight.send, color: Colors.black,)),
          IconButton(onPressed: (){}, icon: Icon(IconlyLight.bookmark, color: Colors.black,)),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: widget.listing.tags!.map((option) {
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
            margin: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage("https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",),
                ),
                const SizedBox(width: 6,),
                 Expanded(
                    child: Text(
                      "${widget.listing.createdBy}",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff0f1015),
                        height: 20/18,
                      ),
                      textAlign: TextAlign.left,
                    )
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        "Required on ",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff0f1015),
                        ),
                      ),
                      Text(
                        "${widget.listing.productDate}",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff0f1015),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Listing Type", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 6,),
                Text("${widget.listing.listingType}", style: TextStyle(
                  color: Color(0xff2F2F2F),
                  fontSize: 13,
                ),),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("For", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 6,),
                Text("${widget.listing.toStyleName}", style: TextStyle(
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
              children:  [
                Text("Instagram Handle", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 6,),
                Text("${widget.listing.instaHandle}", style: TextStyle(
                  color: Color(0xff2F2F2F),
                  fontSize: 13,
                ),),
              ],
            ),
          ),
          Container(
            margin:  EdgeInsets.all(13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Event Category", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 6,),
                Text("${widget.listing.eventCategory}", style: TextStyle(
                  color: Color(0xff2F2F2F),
                  fontSize: 13,
                ),),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Text("Location", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 6,),
                Text("${widget.listing.location}", style: TextStyle(
                  color: Color(0xff2F2F2F),
                  fontSize: 13,
                ),),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Requirement", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 6,),
                Text("${widget.listing.requirement}", style: TextStyle(
                  color: Color(0xff2F2F2F),
                  fontSize: 13,
                ),),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            margin: const EdgeInsets.all(13),
            child: const Text("Moodboard", style: TextStyle(
              color: Color(0xff141414),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),),
          ),
      GridView.builder(
        shrinkWrap: true,
        itemCount: widget.listing.images!.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 60/ 85,
          ),
          itemBuilder: (context, index) => isLoading
              ? _shimmerItem()
              : _gridItem(index)
      ),
       SizedBox(height: 10,),
       Container(
       child: Column(
         children: [
          // Row(
          //  children: const [
          //    CircleAvatar(
          //      radius: 20,
          //      backgroundImage: NetworkImage("https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",),
          //    ),
          //    SizedBox(width: 8,),
          //     Expanded(child: TextField(
          //       decoration: InputDecoration(
          //         hintText: "Add your comments...",
          //         hintStyle: TextStyle(
          //           color: Color(0xffACACAC),
          //           fontSize: 14,
          //         ),
          //         border: InputBorder.none,
          //       ),
          //     ),),
          //  ],
          // ),
           const SizedBox(height: 8,),
           GestureDetector(
             onTap: (){
               Navigator.pushNamed(context, '/listingResponseScreen');
             },
             child: Container(
               height: 50,
               decoration: BoxDecoration(
                 color: Theme.of(context).colorScheme.primary,
                 borderRadius:BorderRadius.circular(10),
               ),
               width: MediaQuery.of(context).size.width -8,
               child: const Center(
                 child: Text("Send your options", style: TextStyle(
                   color: Colors.white,
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                 ),),
               ),
             ),
           ),
           const SizedBox(
             height: 16,
           ),
         ],
       ),
       ),
        ],
      ),
    );
  }

  _gridItem(int index){
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_){
          return PreviewListingGallery(selectedItems: widget.listing.images!,);
        }));
        // Navigator.pushNamed(context, '/lookbookImageDetailsScreen');
      },
      child: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(
                // '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}',
                "${widget.listing.images![index]}"
              ),
              fit: BoxFit.cover,
            ),
          ),
        ],
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


class OptionChipDisplay extends StatelessWidget {
  final String title;

  OptionChipDisplay({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin: const EdgeInsets.only(
          top: 9.0,
          left: 6.0,
          right: 6.0,
          bottom: 9.0
      ),
      padding:const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color:const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff303030),
              height: 18/12,
            ),
          ),
        ],
      ),
    );
  }
}
