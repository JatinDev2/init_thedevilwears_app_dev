import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:faker_dart/faker_dart.dart';


class Details_Screen extends StatefulWidget {
  const Details_Screen({Key? key}) : super(key: key);

  @override
  State<Details_Screen> createState() => _Details_ScreenState();
}

class _Details_ScreenState extends State<Details_Screen> {

  final faker = Faker.instance;
  List<String> filterOptions = [
    'Clothing',
    'Shoes',
    'Accessories',
    'Bags',
    'Jewelry',
    'Birthday',
    'Anniversary',
    'Graduation',
    'Holiday',
    'Prom',
    'Movie Promotions',
    'Shoots',
    'Events',
    'Concerts',
    'Weddings',
    'Public Appearances',
  ];
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
                    children: filterOptions.map((option) {
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
                const Expanded(
                    child: Text(
                      "Tanya Ghavri",
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
                    children: const [
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
                        "18 Oct",
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
              children: const [
                Text("Listing Type", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 6,),
                Text("Sourcing", style: TextStyle(
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
              children: const [
                Text("For", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 6,),
                Text("Alia Bhatt", style: TextStyle(
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
              children: const [
                Text("Instagram Handle", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 6,),
                Text("https://www.instagram.com/vickykaushal", style: TextStyle(
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
              children: const [
                Text("Event Category", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 6,),
                Text("Movie Promotion", style: TextStyle(
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
              children: const [
                Text("Location", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 6,),
                Text("Bandra East, Mumbai 400 088", style: TextStyle(
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
              children: const [
                Text("Requirement", style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 6,),
                Text("A mustard yellow traditional outfit is required for alia bhatt for her new movie promotions. The fabric needs to have the following details of the clothes. It is supposed to be yellow in color. The theme of the even is more inclined towards formal wear. Kindly keep theses specifications in mind before applying your entry.\n\nA mustard yellow traditional outfit is required for alia bhatt for her new movie promotions. The fabric needs to have the following details of the clothes. It is supposed to be yellow in color. The theme of the even is more inclined towards formal wear. Kindly keep theses specifications in mind before applying your entry.", style: TextStyle(
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
        itemCount: 11,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 60/ 85,
          ),
          itemBuilder: (context, index) => isLoading
              ? _shimmerItem()
              : _gridItem()
      ),
       SizedBox(height: 10,),
       Container(
       child: Column(
         children: [
          Row(
           children: const [
             CircleAvatar(
               radius: 20,
               backgroundImage: NetworkImage("https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",),
             ),
             SizedBox(width: 8,),
              Expanded(child: TextField(
                decoration: InputDecoration(
                  hintText: "Add your comments...",
                  hintStyle: TextStyle(
                    color: Color(0xffACACAC),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),),
           ],
          ),
           const SizedBox(height: 8,),
           GestureDetector(
             onTap: (){
               Navigator.pushNamed(context, '/listingResponseScreen');
             },
             child: Container(
               height: 50,
               decoration: BoxDecoration(
                 color: Colors.orange,
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

  _gridItem() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/lookbookImageDetailsScreen');
      },
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
