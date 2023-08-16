import 'dart:math';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

import 'applicationDetails.dart';

class applicationsListing extends StatefulWidget {
  const applicationsListing({super.key});

  @override
  State<applicationsListing> createState() => _applicationsListingState();
}

class _applicationsListingState extends State<applicationsListing> {
  final faker = Faker.instance;
  bool isLoading=true;
  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    generateItems();
    super.initState();
  }

  List generateItems() {
    final faker = Faker.instance;
    for (int i = 0; i < 4; i++){
      items.add(
        '${faker.image.unsplash.image(keyword: 'fashion')},${Random().nextInt(100)}',
      );
    }
    isLoading=false;
    setState(() {});
    return items;
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
  body: Container(
    color: Color(0xffF0F0F0),
    child: Column(
children: [
  _buildCustomCard(),

],
    ),
  ),
    );
  }
  Widget _buildCustomCard(){
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(16),
      child: Container(
        // height: 290,
        margin: EdgeInsets.all(4.0),
        child: InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_){
              return applicationDetails();
            }));
          },
          child: Column(
            children: [
              Container(
                // height: 50,
                // width: MediaQuery.of(context).size.width,
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
                          "Shaleen Nair",
                          style:  TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0f1015),
                            height: 20/18,
                          ),
                        )
                    ),
                    Container(
                      child:const Text(
                        "44 images",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8b8b8b),
                          height: 18/12,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Preview',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2F2F2F),
                          ),
                          children: [
                            TextSpan(
                              text: ' A mustard yellow traditional outfit is required for Alia Bhatt for her new movie promotions. The fabric...',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff424242),
                              ),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: GridView.builder(
                          shrinkWrap: true,
                            itemCount: items.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 3,
                              crossAxisSpacing: 3,
                              childAspectRatio: 40 / 70,
                            ),
                            itemBuilder: (context, index) => isLoading
                                ? _shimmerItem()
                                : _gridItem(index)
                        ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      // height: 25,
                      // width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        bottom: 8.0
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "37 mins ago ",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff8b8b8b),
                              height: 18/12,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const Spacer(),
                      Text(
                        "Call now ",
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                          height: 20/14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                          SvgPicture.asset("assets/callOrange.svg"),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _gridItem(int index){
    if(index==3){
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/lookbookDetailsScreen');
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            children: [
              /// Background Image
              Positioned.fill(
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(
                    '${items[index]}',
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
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ],
                    ),
                  ),
                  child:Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 0, right: 0),
                      width: 24,
                      height: 24,
                      child: Text(
                        "+40",
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/lookbookDetailsScreen');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: [
            /// Background Image
            Positioned.fill(
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                  '${items[index]}',
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
                child:Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 0, right: 0),
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset("assets/multiple.svg"),
                  ),
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
