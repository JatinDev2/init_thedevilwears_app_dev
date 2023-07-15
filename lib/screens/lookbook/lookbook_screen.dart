import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:math';

import 'package:faker_dart/faker_dart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class LookbookScreen extends StatefulWidget {
  const LookbookScreen({Key? key}) : super(key: key);

  @override
  State<LookbookScreen> createState() => _LookbookScreenState();
}

class _LookbookScreenState extends State<LookbookScreen> {

  final faker = Faker.instance;
  bool isLoading = true;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState((){
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      child: RefreshIndicator(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 60.h,
                child: Center(
                    child: Text(
                      "CoffeeCola",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    )
                )
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 100 / 150,
                  ),
                  itemBuilder: (context, index) => isLoading
                    ? _shimmerItem()
                    : _gridItem()
                ),
              ),
            ],
          ),
        ),
        onRefresh: (){
          setState(() => isLoading = true);
          return Future.delayed(const Duration(seconds: 1), () {
            setState(() => isLoading = false);
          });
        },
      ),
    );
  }

  _gridItem() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/lookbookDetailsScreen');
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

  @override
  void dispose() {
    super.dispose();
  }
}
